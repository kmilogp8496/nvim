pcall(require('telescope').load_extension, 'live_grep_args')

local extensions = require('telescope').extensions

vim.keymap.set('n', '<leader>sg', extensions.live_grep_args.live_grep_args, { desc = '[S]earch by [G]rep' })
