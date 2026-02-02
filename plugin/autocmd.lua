vim.api.nvim_create_autocmd('BufNew', {
  pattern = '*.lua',
  callback = function(args)
    vim.keymap.set({ 'n', 'v' }, '<leader>l', '<Cmd>so %<Cr>', {
      buffer = args.buf,
      desc = 'Source current [L]ua file',
    })
  end,
})

vim.api.nvim_create_autocmd('BufNew', {
  pattern = '*.php',
  callback = function(args)
    vim.keymap.set({ 'n', 'v' }, '<leader>pc', '<Cmd>PhpSetupFile %<Cr>', {
      buffer = args.buf,
      desc = 'Setup [P]HP [C]lass Namespace',
    })
  end,
})
