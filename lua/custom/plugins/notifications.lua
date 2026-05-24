vim.pack.add {
  'https://github.com/rcarriga/nvim-notify',
}

local ok, notify = pcall(require, 'notify')
if ok then vim.notify = notify end
