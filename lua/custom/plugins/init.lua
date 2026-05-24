local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'custom', 'plugins')
local modules = {}

for file_name, entry_type in vim.fs.dir(plugins_dir) do
  if entry_type == 'file' and file_name:match '%.lua$' and file_name ~= 'init.lua' then table.insert(modules, (file_name:gsub('%.lua$', ''))) end
end

table.sort(modules)

for _, module in ipairs(modules) do
  require('custom.plugins.' .. module)
end
