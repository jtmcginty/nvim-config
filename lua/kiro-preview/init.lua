local M = {}

local recent_files = {}
local file_mtimes = {}
local file_contents = {} -- cached line contents for diffing
local file_last_event = {} -- debounce: last event time per filepath (ms)
local timer = nil

local FLASH_NS = vim.api.nvim_create_namespace("kiro_preview_flash")
local MAX_QF_ENTRIES = 30
local DEBOUNCE_MS = 100

-- ============================================================================
-- Terminal / window helpers
-- ============================================================================

local function is_ai_terminal(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  return bufname:match("term://.*kiro") ~= nil or bufname:match("term://.*claude") ~= nil
end

local function get_ai_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if is_ai_terminal(vim.api.nvim_win_get_buf(win)) then
      return win
    end
  end
  return nil
end

local function stop_timer()
  if timer then
    if timer.stop then timer:stop() end
    if timer.close then timer:close() end
    timer = nil
  end
end

-- ============================================================================
-- File content cache
-- ============================================================================

local function cache_file(filepath)
  local lines = {}
  local f = io.open(filepath, "r")
  if not f then return end
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()
  file_contents[filepath] = lines
end

-- ============================================================================
-- Diffing: find change blocks
-- ============================================================================

--- Returns list of {start=N, count=N, text=string} blocks
--- Uses a simple but correct diff approach: finds matching "anchor" lines
--- to detect insertions/deletions rather than naive line-by-line comparison
local function find_change_blocks(filepath)
  local old_lines = file_contents[filepath]

  local new_lines = {}
  local f = io.open(filepath, "r")
  if not f then return {} end
  for line in f:lines() do
    table.insert(new_lines, line)
  end
  f:close()

  -- No prior cache: first time seeing this file
  if not old_lines then
    if not file_mtimes[filepath] then
      -- Truly new file created during this session
      if #new_lines == 0 then return {} end
      return { { start = 1, count = #new_lines, text = new_lines[1] or "" } }
    end
    return {}
  end

  -- Use vim's built-in diff to find changed line ranges
  -- Compare old vs new using vim.diff (available in Neovim 0.6+)
  local old_text = table.concat(old_lines, "\n") .. "\n"
  local new_text = table.concat(new_lines, "\n") .. "\n"

  local ok, diff_result = pcall(vim.diff, old_text, new_text, { result_type = "indices" })
  if not ok or not diff_result then
    return {}
  end

  -- vim.diff with result_type="indices" returns list of {old_start, old_count, new_start, new_count}
  local blocks = {}
  for _, hunk in ipairs(diff_result) do
    local new_start = hunk[3]
    local new_count = hunk[4]
    if new_count > 0 then
      local text = new_lines[new_start] or ""
      table.insert(blocks, { start = new_start, count = new_count, text = text })
    elseif new_start > 0 then
      -- Pure deletion: highlight the line where content was removed
      local text = new_lines[new_start] or ""
      table.insert(blocks, { start = new_start, count = 1, text = text })
    end
  end

  return blocks
end

-- ============================================================================
-- Quickfix management
-- ============================================================================

local function update_quickfix(filepath, blocks)
  if #blocks == 0 then return end

  local existing = vim.fn.getqflist()

  -- Build ranges for dedup
  local new_ranges = {}
  for _, block in ipairs(blocks) do
    table.insert(new_ranges, { start = block.start, stop = block.start + block.count - 1 })
  end

  -- Filter out old entries for same filepath that overlap new blocks
  local kept = {}
  for _, entry in ipairs(existing) do
    local entry_filepath = ""
    if entry.bufnr and entry.bufnr > 0 then
      local ok, name = pcall(vim.api.nvim_buf_get_name, entry.bufnr)
      if ok then entry_filepath = name end
    end

    if entry_filepath == filepath then
      local dominated = false
      for _, range in ipairs(new_ranges) do
        if entry.lnum >= range.start and entry.lnum <= range.stop then
          dominated = true
          break
        end
      end
      if not dominated then
        table.insert(kept, entry)
      end
    else
      table.insert(kept, entry)
    end
  end

  -- Add new entries: "[N lines] <first line content>"
  for _, block in ipairs(blocks) do
    table.insert(kept, {
      filename = filepath,
      lnum = block.start,
      col = 1,
      text = string.format("[%d lines] %s", block.count, block.text),
    })
  end

  -- Cap at MAX_QF_ENTRIES (trim oldest from front)
  while #kept > MAX_QF_ENTRIES do
    table.remove(kept, 1)
  end

  vim.fn.setqflist(kept, "r")
end

-- ============================================================================
-- Flash highlight
-- ============================================================================

local function flash_block_at_cursor()
  local qflist = vim.fn.getqflist()
  local idx = vim.fn.getqflist({ idx = 0 }).idx
  if idx < 1 or idx > #qflist then return end

  local entry = qflist[idx]
  local line_count = 1
  local n = entry.text:match("^%[(%d+) lines%]")
  if n then line_count = tonumber(n) or 1 end

  local bufnr = vim.api.nvim_get_current_buf()
  local start_line = entry.lnum - 1 -- 0-indexed
  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  local end_line = math.min(start_line + line_count, total_lines)

  vim.api.nvim_buf_clear_namespace(bufnr, FLASH_NS, 0, -1)

  for i = start_line, end_line - 1 do
    vim.api.nvim_buf_add_highlight(bufnr, FLASH_NS, "CurSearch", i, 0, -1)
  end

  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_clear_namespace(bufnr, FLASH_NS, 0, -1)
    end
  end, 300)
end

-- ============================================================================
-- Quickfix cycling with wraparound
-- ============================================================================

local function cycle_next()
  local qflist = vim.fn.getqflist()
  if #qflist == 0 then return end
  local idx = vim.fn.getqflist({ idx = 0 }).idx
  if idx >= #qflist then
    vim.cmd("cfirst")
  else
    vim.cmd("cnext")
  end
  flash_block_at_cursor()
end

local function cycle_prev()
  local qflist = vim.fn.getqflist()
  if #qflist == 0 then return end
  local idx = vim.fn.getqflist({ idx = 0 }).idx
  if idx <= 1 then
    vim.cmd("clast")
  else
    vim.cmd("cprev")
  end
  flash_block_at_cursor()
end

-- ============================================================================
-- Ignore rules
-- ============================================================================

local function should_ignore(filepath)
  local filename = vim.fn.fnamemodify(filepath, ':t')
  local ignore_files = { '.coverage', '.DS_Store', 'Thumbs.db', 'coverage.xml' }
  for _, name in ipairs(ignore_files) do
    if filename == name or filename:match('^%.coverage%.') then
      return true
    end
  end

  local extensions = {
    '.pyc', '.pyo', '.so', '.dylib', '.dll', '.exe', '.bin', '.o', '.a',
    '.jpg', '.jpeg', '.png', '.gif', '.pdf', '.zip', '.tar', '.gz',
    '.class', '.jar', '.war', '.wasm',
  }
  for _, ext in ipairs(extensions) do
    if filepath:sub(-#ext) == ext then return true end
  end

  local ignore_patterns = {
    '%.pytest_cache/', '__pycache__/', '%.venv/', 'venv/', '%.ruff_cache/',
    'htmlcov/', '%.tox/', '%.egg%-info/', '%.mypy_cache/', '%.hypothesis/',
    'wheels/', 'sdist/',
    'node_modules/', '%.next/', '%.nuxt/', '%.turbo/', '%.parcel%-cache/',
    '%.vite/', '%.webpack/', '%.rollup%.cache/', '%.svelte%-kit/', '%.nyc_output/',
    'dist/', 'build/', 'out/', 'coverage/', 'tmp/', 'temp/', 'logs/',
    'target/', 'vendor/', '%.gradle/', 'bin/',
    '%.terraform/', '%.git/', '%.cache/',
  }
  for _, pattern in ipairs(ignore_patterns) do
    if filepath:match(pattern) then return true end
  end

  return false
end

-- ============================================================================
-- Main handler: open file, jump to change, update quickfix
-- ============================================================================

local function open_in_main_pane(filepath, blocks)
  if should_ignore(filepath) then return end

  local ai_win = get_ai_window()
  if not ai_win then return end

  local target_line = (#blocks > 0) and blocks[1].start or nil

  -- Save current window
  local current_win = vim.api.nvim_get_current_win()

  -- Find main editor window
  local target_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local filetype = vim.bo[buf].filetype
    if win ~= ai_win and filetype ~= 'neo-tree' then
      target_win = win
      break
    end
  end

  if not target_win then return end

  -- Open/reload buffer and jump
  local bufnr = vim.fn.bufnr(filepath)
  if bufnr ~= -1 then
    vim.api.nvim_win_set_buf(target_win, bufnr)
    vim.api.nvim_win_call(target_win, function()
      vim.cmd("checktime")
      if target_line then
        vim.cmd(tostring(target_line))
        vim.cmd("normal! zz")
      end
    end)
  else
    vim.api.nvim_set_current_win(target_win)
    vim.cmd("keepalt edit " .. vim.fn.fnameescape(filepath))
    if target_line then
      vim.cmd(tostring(target_line))
      vim.cmd("normal! zz")
    end
  end

  -- Return focus to AI terminal
  if vim.api.nvim_win_is_valid(current_win) then
    vim.api.nvim_set_current_win(current_win)
  end

  -- Flash highlight the changed blocks
  if #blocks > 0 then
    local flash_bufnr = vim.api.nvim_win_get_buf(target_win)
    vim.api.nvim_buf_clear_namespace(flash_bufnr, FLASH_NS, 0, -1)
    for _, block in ipairs(blocks) do
      local start_line = block.start - 1 -- 0-indexed
      local total = vim.api.nvim_buf_line_count(flash_bufnr)
      local end_line = math.min(start_line + block.count, total)
      for i = start_line, end_line - 1 do
        vim.api.nvim_buf_add_highlight(flash_bufnr, FLASH_NS, "CurSearch", i, 0, -1)
      end
    end
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(flash_bufnr) then
        vim.api.nvim_buf_clear_namespace(flash_bufnr, FLASH_NS, 0, -1)
      end
    end, 300)
  end

  -- Reveal in Neo-tree
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'neo-tree' then
      local ok, filesystem = pcall(require, 'neo-tree.sources.filesystem')
      if ok then
        local state = require('neo-tree.sources.manager').get_state('filesystem')
        filesystem.navigate(state, state.path, filepath)
      end
      break
    end
  end

  -- Update quickfix
  update_quickfix(filepath, blocks)

  print("AI modified: " .. vim.fn.fnamemodify(filepath, ":~:."))
end

-- ============================================================================
-- Setup
-- ============================================================================

function M.setup()
  -- Keymaps: Option+= / Option+- for cycling quickfix with flash
  vim.keymap.set("n", "<M-=>", cycle_next, { desc = "Next AI change block" })
  vim.keymap.set("n", "<M-->", cycle_prev, { desc = "Prev AI change block" })
  vim.keymap.set("n", "≠", cycle_next, { desc = "Next AI change block" })
  vim.keymap.set("n", "–", cycle_prev, { desc = "Prev AI change block" })

  -- Poll for AI terminal, then start file watcher
  local poll = vim.loop.new_timer()
  poll:start(500, 1000, vim.schedule_wrap(function()
    if timer then
      poll:stop()
      poll:close()
      return
    end
    if not get_ai_window() then return end

    local cwd = vim.fn.getcwd()
    local handle = vim.loop.new_fs_event()

    handle:start(cwd, {recursive = true}, vim.schedule_wrap(function(err, filename)
      if err then return end
      if not get_ai_window() then
        handle:stop()
        return
      end
      if not filename then return end

      local filepath = cwd .. '/' .. filename
      if vim.fn.filereadable(filepath) ~= 1 then return end

      -- Debounce: skip if same filepath handled within DEBOUNCE_MS
      local now = vim.loop.now()
      local last = file_last_event[filepath]
      if last and (now - last) < DEBOUNCE_MS then return end
      file_last_event[filepath] = now

      -- Mtime check
      local stat = vim.loop.fs_stat(filepath)
      if stat then
        local mtime = stat.mtime.sec
        local last_mtime = file_mtimes[filepath]
        if last_mtime and mtime <= last_mtime then return end
        file_mtimes[filepath] = mtime
      end

      -- Diff and handle
      recent_files[filepath] = os.time()
      local blocks = find_change_blocks(filepath)
      cache_file(filepath)
      open_in_main_pane(filepath, blocks)
    end))

    timer = handle
    poll:stop()
    poll:close()
  end))

  -- Stop watcher on exit
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = stop_timer,
  })

  -- List recent files command
  vim.api.nvim_create_user_command("KiroPreviewList", function()
    local sorted = {}
    for file, time in pairs(recent_files) do
      table.insert(sorted, { file = file, time = time })
    end
    table.sort(sorted, function(a, b) return a.time > b.time end)
    print("Recently modified:")
    for i, item in ipairs(sorted) do
      if i <= 10 then
        print(string.format("%d. %s", i, vim.fn.fnamemodify(item.file, ":~:.")))
      end
    end
  end, {})
end

return M
