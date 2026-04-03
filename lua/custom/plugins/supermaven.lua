return {
  {
    'supermaven-inc/supermaven-nvim',
    event = 'InsertEnter',
    opts = {
      keymaps = {
        accept_suggestion = '<C-l>',
        clear_suggestion = '<C-]>',
        accept_word = '<C-j>',
        next_word = '<C-k>',
      },
      ignore_filetypes = {
        Avante = true,
        TelescopePrompt = true,
        DressingInput = true,
        dressinginput = true,
        snacks_input = true,
      },
      condition = function()
        local name = vim.fs.basename(vim.api.nvim_buf_get_name(0))
        if name == '.env' or name:match '^%.env' then return true end
        return vim.fn.pumvisible() == 1
      end,
    },
    config = function(_, opts) require('supermaven-nvim').setup(opts) end,
  },
}
