vim.keymap.set(
  'n',
  '<leader>yc',
  function() vim.fn.setreg('+', vim.fn.fnamemodify(vim.fn.expand '%:p', ':.')) end,
  { desc = 'Cop[y] relative [c]urrent file path (from cwd) to clipboard' }
)

vim.keymap.set('n', '<leader>yn', function() vim.fn.setreg('+', vim.fn.expand '%:t') end, { desc = 'Cop[y] current file name' })

vim.keymap.set('n', '<leader>ln', vim.cmd.cnext, { desc = '[N]ext quick fix [l]ist item' })
vim.keymap.set('n', '<leader>lp', vim.cmd.cprev, { desc = '[P]revious quick fix [l]ist item' })

-- Use InsertTimestamp command with keymap
vim.keymap.set('i', '<C-t>', '<Cmd>InsertTimestamp<CR>', { desc = 'Insert current Unix timestamp at cursor position' })
vim.keymap.set('n', '<leader>tc', '<Cmd>InsertTimestamp<CR>', { desc = 'Insert [C]urrent Unix [T]imestamp at cursor position' })
