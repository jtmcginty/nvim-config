-- ============================================================================
-- Ansible: Auto-detect Ansible YAML files
-- ============================================================================
-- Sets filetype to yaml.ansible for Ansible-specific LSP features

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = {
    '*/playbooks/*.yaml',
    '*/playbooks/*.yml',
    '*playbook*.yaml',
    '*playbook*.yml',
    '*.ansible.yaml',
    '*.ansible.yml',
  },
  callback = function()
    vim.bo.filetype = 'yaml.ansible'
  end,
})

vim.keymap.set('n', '<leader>ta', function()
  vim.bo.filetype = 'yaml.ansible'
end, { desc = 'Toggle [A]nsible filetype' })

return {}
