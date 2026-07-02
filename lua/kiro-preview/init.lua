local M = {}

local recent_files = {}
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
-- Diffing
-- ============================================================================

--- Returns list of {start=N, count=N, text=string} blocks
local function find_change_blocks(filepath)
  local old_lines = file_contents[filepath]

  local new_lines = {}
  local f = io.open(filepath, "r")
  if not f then return {} end
  for line in f:lines() do
    table.insert(new_lines, line)
  end
  f:close()

  if not old_lines then
    return {}
  end

  local old_text = table.concat(old_lines, "\n") .. "\n"
  local new_text = table.concat(new_lines, "\n") .. "\n"

  local ok, diff_result = pcall(vim.diff, old_text, new_text, { result_type = "indices" })
  if not ok or not diff_result then
    return {}
  end

  local blocks = {}
  for _, hunk in ipairs(diff_result) do
    local new_start = hunk[3]
    local new_count = hunk[4]
    if new_count > 0 then
      local text = new_lines[new_start] or ""
      table.insert(blocks, { start = new_start, count = new_count, text = text })
    elseif new_start > 0 then
      local text = new_lines[new_start] or ""
      table.insert(blocks, { start = new_start, count = 1, text = text })
    end
  end

  return blocks
end

-- ============================================================================
-- Quickfix
-- ============================================================================

local function update_quickfix(filepath, blocks)
  if #blocks == 0 then return end

  local existing = vim.fn.getqflist()

  local new_ranges = {}
  for _, block in ipairs(blocks) do
    table.insert(new_ranges, { start = block.start, stop = block.start + block.count - 1 })
  end

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

  for _, block in ipairs(blocks) do
    table.insert(kept, {
      filename = filepath,
      lnum = block.start,
      col = 1,
      text = string.format("[%d lines] %s", block.count, block.text),
    })
  end

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
  local start_line = entry.lnum - 1
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
-- Quickfix cycling
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
  local ignore_files = { '.coverage', '.DS_Store', 'Thumbs.db', 'coverage.xml', 'Cargo.lock' }
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
    '/%.pytest_cache/', '/__pycache__/', '/%.venv/', '/venv/', '/%.ruff_cache/',
    '/htmlcov/', '/%.tox/', '/%.egg%-info/', '/%.mypy_cache/', '/%.hypothesis/',
    '/wheels/', '/sdist/',
    '/node_modules/', '/%.next/', '/%.nuxt/', '/%.turbo/', '/%.parcel%-cache/',
    '/%.vite/', '/%.webpack/', '/%.rollup%.cache/', '/%.svelte%-kit/', '/%.nyc_output/',
    '/dist/', '/build/', '/out/', '/coverage/', '/tmp/', '/temp/', '/logs/',
    '/target/', '/vendor/', '/%.gradle/',
    '/%.terraform/', '/%.git/', '/%.cache/',
  }
  for _, pattern in ipairs(ignore_patterns) do
    if filepath:match(pattern) then return true end
  end

  return false
end

-- ============================================================================
-- Open file, jump to change, flash, update quickfix
-- ============================================================================

local function open_in_main_pane(filepath, blocks)
  if should_ignore(filepath) then return end

  local ai_win = get_ai_window()
  if not ai_win then return end

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

  -- Open or reload buffer
  local bufnr = vim.fn.bufnr(filepath)
  if bufnr ~= -1 then
    vim.api.nvim_win_set_buf(target_win, bufnr)
    vim.api.nvim_win_call(target_win, function()
      vim.cmd("checktime")
    end)
  else
    vim.api.nvim_set_current_win(target_win)
    vim.cmd("keepalt edit " .. vim.fn.fnameescape(filepath))
    bufnr = vim.api.nvim_get_current_buf()
  end

  -- Jump to first change and center
  if #blocks > 0 then
    local target_line = blocks[1].start
    vim.api.nvim_win_call(target_win, function()
      vim.cmd(tostring(target_line))
      vim.cmd("normal! zz")
    end)
  end

  -- Flash highlight changed blocks
  if #blocks > 0 then
    local flash_bufnr = vim.api.nvim_win_get_buf(target_win)
    vim.api.nvim_buf_clear_namespace(flash_bufnr, FLASH_NS, 0, -1)
    local total = vim.api.nvim_buf_line_count(flash_bufnr)
    for _, block in ipairs(blocks) do
      local start_line = block.start - 1
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

  -- Return focus to AI terminal
  if vim.api.nvim_win_is_valid(current_win) then
    vim.api.nvim_set_current_win(current_win)
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
  -- Keymaps
  vim.keymap.set("n", "<M-=>", cycle_next, { desc = "Next AI change block" })
  vim.keymap.set("n", "<M-->", cycle_prev, { desc = "Prev AI change block" })
  vim.keymap.set("n", "≠", cycle_next, { desc = "Next AI change block" })
  vim.keymap.set("n", "–", cycle_prev, { desc = "Prev AI change block" })

  -- Poll for AI terminal, then start file watcher
  local poll = vim.loop.new_timer()
  poll:start(500, 1000, vim.schedule_wrap(function()
    if timer then
      if poll:is_active() then poll:stop() end
      if not poll:is_closing() then poll:close() end
      return
    end
    if not get_ai_window() then return end

    -- Claim immediately to prevent re-entry
    timer = true

    local cwd = vim.fn.getcwd()

    -- Cache all source files for diffing (skips ignored dirs entirely)
    local function cache_tree(dir)
      local scan = vim.loop.fs_scandir(dir)
      if not scan then return end
      while true do
        local name, ftype = vim.loop.fs_scandir_next(scan)
        if not name then break end
        local full = dir .. '/' .. name
        if ftype == 'directory' then
          if not should_ignore(full .. '/') then
            cache_tree(full)
          end
        elseif ftype == 'file' then
          if not should_ignore(full) then
            cache_file(full)
          end
        end
      end
    end
    cache_tree(cwd)

    -- Start fs_event watcher
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
      if should_ignore(filepath) then return end

      -- Debounce
      local now = vim.loop.now()
      local last = file_last_event[filepath]
      if last and (now - last) < DEBOUNCE_MS then return end
      file_last_event[filepath] = now

      -- Diff, cache, open
      recent_files[filepath] = os.time()
      local blocks = find_change_blocks(filepath)
      cache_file(filepath)
      open_in_main_pane(filepath, blocks)
    end))

    timer = handle
    if poll:is_active() then poll:stop() end
    if not poll:is_closing() then poll:close() end
  end))

  -- Keep cache warm when user saves a file (new baseline)
  vim.api.nvim_create_autocmd({"BufWritePost"}, {
    callback = function(ev)
      local filepath = vim.api.nvim_buf_get_name(ev.buf)
      if filepath == "" then return end
      if should_ignore(filepath) then return end
      file_contents[filepath] = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
    end,
  })

  -- Stop watcher on exit
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = stop_timer,
  })

  -- List recent files
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
