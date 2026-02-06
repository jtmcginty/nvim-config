-- ============================================================================
-- Auto-reload: Aggressive file watching
-- ============================================================================
-- Checks for file changes every 500ms in all buffers

return {
  'nvim-lua/plenary.nvim',
  config = function()
    -- Timer to check for file changes
    local timer = vim.loop.new_timer()
    timer:start(500, 500, vim.schedule_wrap(function()
      -- Check all file buffers for changes
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == '' then
          local bufname = vim.api.nvim_buf_get_name(buf)
          if bufname ~= '' and vim.loop.fs_stat(bufname) then
            vim.api.nvim_buf_call(buf, function()
              pcall(vim.cmd, 'checktime')
            end)
          end
        end
      end
    end))
  end,
}
