-- autopairs
-- https://github.com/windwp/nvim-autopairs

vim.pack.add {
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/windwp/nvim-ts-autotag',
}
require('nvim-autopairs').setup {}

require('nvim-ts-autotag').setup {
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
}
