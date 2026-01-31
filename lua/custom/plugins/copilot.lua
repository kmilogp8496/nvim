-- zbirenbaum/copilot.lua: pure Lua replacement for github/copilot.vim
-- Only virtual text (ghost text) suggestions, no completion menu integration.
return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = '<Tab>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = false },
      -- Do not attach to .env files (avoid sending secrets to Copilot)
      should_attach = function(_, bufname)
        local name = vim.fs.basename(bufname)
        if name == '.env' or name:match '^%.env' then return false end
        if not vim.bo.buflisted then return false end
        if vim.bo.buftype ~= '' then return false end
        return true
      end,
    }
  end,
}
