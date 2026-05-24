vim.pack.add {
  'https://github.com/sphamba/smear-cursor.nvim',
}

local ok, smear_cursor = pcall(require, 'smear_cursor')
if not ok then return end

smear_cursor.setup {
  stiffness = 0.8,
  trailing_stiffness = 0.6,
  stiffness_insert_mode = 0.7,
  trailing_stiffness_insert_mode = 0.7,
  damping = 0.95,
  damping_insert_mode = 0.95,
  distance_stop_animating = 0.5,
}
