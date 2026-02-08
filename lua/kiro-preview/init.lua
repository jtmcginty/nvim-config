local M = {}

local recent_files = {}
local file_mtimes = {}
local timer = nil

-- Check if buffer is AI terminal (Kiro or Claude)
local function is_ai_terminal(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  return bufname:match("term://.*kiro") ~= nil or bufname:match("term://.*claude") ~= nil
end

-- Find AI terminal window (Kiro or Claude)
local function get_ai_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if is_ai_terminal(vim.api.nvim_win_get_buf(win)) then
      return win
    end
  end
  return nil
end

-- Stop the file watcher timer
local function stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

-- Open file in main pane (not AI terminal)
local function open_in_main_pane(filepath)
  local ai_win = get_ai_window()
  if not ai_win then
    return
  end

  -- Save current window
  local current_win = vim.api.nvim_get_current_win()

  -- Find the main editor window (not AI terminal, not neo-tree)
  local target_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
    
    -- Skip AI terminal and neo-tree
    if win ~= ai_win and filetype ~= 'neo-tree' then
      target_win = win
      break
    end
  end

  if not target_win then
    return
  end

  -- Check if buffer already exists
  local bufnr = vim.fn.bufnr(filepath)
  if bufnr ~= -1 then
    -- Buffer exists, just switch to it
    vim.api.nvim_win_set_buf(target_win, bufnr)
  else
    -- Temporarily switch to target window to open file
    vim.api.nvim_set_current_win(target_win)
    vim.cmd("keepalt edit " .. vim.fn.fnameescape(filepath))
  end
  
  -- Return focus to original window (likely AI terminal)
  if vim.api.nvim_win_is_valid(current_win) then
    vim.api.nvim_set_current_win(current_win)
  end
  
  print("AI modified: " .. vim.fn.fnamemodify(filepath, ":~:."))
end

-- Check for file changes in current directory
local function check_for_changes()
  if not get_ai_window() then
    stop_timer()
    return
  end

  local cwd = vim.fn.getcwd()
  local files = vim.fn.glob(cwd .. "/**/*", false, true)

  for _, file in ipairs(files) do
    if vim.fn.isdirectory(file) == 0 and vim.fn.filereadable(file) == 1 then
      local stat = vim.loop.fs_stat(file)
      if stat then
        local mtime = stat.mtime.sec
        local last_mtime = file_mtimes[file]

        if last_mtime and mtime > last_mtime then
          -- File was modified
          recent_files[file] = os.time()
          open_in_main_pane(file)
        end

        file_mtimes[file] = mtime
      end
    end
  end
end

function M.setup()
  -- Initialize file mtimes
  local cwd = vim.fn.getcwd()
  local files = vim.fn.glob(cwd .. "/**/*", false, true)
  for _, file in ipairs(files) do
    if vim.fn.isdirectory(file) == 0 then
      local stat = vim.loop.fs_stat(file)
      if stat then
        file_mtimes[file] = stat.mtime.sec
      end
    end
  end

  -- Poll for changes every 500ms
  timer = vim.loop.new_timer()
  timer:start(500, 500, vim.schedule_wrap(check_for_changes))

  -- Stop timer on Neovim exit
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = stop_timer,
  })

  -- Command to list recent files
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
