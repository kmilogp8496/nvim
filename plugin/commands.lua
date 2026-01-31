-- Command for inserting unix timestamp into the cursor position
vim.api.nvim_create_user_command('InsertTimestamp', function()
  local timestamp = os.time()
  vim.api.nvim_put({ tostring(timestamp) }, '', true, true)
end, { desc = 'Insert current Unix timestamp at cursor position' })
