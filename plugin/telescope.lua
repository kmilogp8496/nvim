local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then return end

pcall(telescope.load_extension, 'live_grep_args')

local has_live_grep_args, live_grep_args = pcall(function() return telescope.extensions.live_grep_args end)
if has_live_grep_args and live_grep_args then
  vim.keymap.set('n', '<leader>sg', live_grep_args.live_grep_args, { desc = '[S]earch by [G]rep' })
end
