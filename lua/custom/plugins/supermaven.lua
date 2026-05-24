vim.pack.add {
  'https://github.com/supermaven-inc/supermaven-nvim',
}

local ok, supermaven = pcall(require, 'supermaven-nvim')
if not ok then return end

supermaven.setup {
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
}
