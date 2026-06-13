vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function(args)
    vim.keymap.set({ 'n', 'v' }, '<leader>rg', '<Cmd>!go run %<Cr>', {
      buffer = args.buf,
      desc = '[R]un [G]o file',
    })

    vim.keymap.set({ 'n', 'v' }, '<leader>rb', '<Cmd>!go build %<Cr>', {
      buffer = args.buf,
      desc = '[R]un Go [B]uild',
    })
  end,
})
