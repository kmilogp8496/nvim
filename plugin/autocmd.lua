vim.api.nvim_create_autocmd('BufNew', {
  pattern = '*.lua',
  callback = function(args)
    vim.keymap.set({ 'n', 'v' }, '<leader>rl', '<Cmd>so %<Cr>', {
      buffer = args.buf,
      desc = 'Source current [L]ua file',
    })
  end,
})

vim.api.nvim_create_autocmd('BufNew', {
  pattern = '*.php',
  callback = function(args)
    vim.keymap.set({ 'n', 'v' }, '<leader>rm', '<Cmd>PhpSetupFile %<Cr>', {
      buffer = args.buf,
      desc = '[S]etup PHP Class Namespace',
    })
  end,
})

vim.api.nvim_create_autocmd('BufNew', {
  callback = function(args)
    vim.keymap.set({ 'n', 'v' }, '<leader>rt', '<Cmd>RunFileTest %<Cr>', {
      buffer = args.buf,
      desc = '[R]un [T]ests for current file',
    })
  end,
})
