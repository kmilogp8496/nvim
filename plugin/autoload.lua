PackageManager = {
  ---@param package_name string
  ---@param server_config table
  add_lsp_package = function(self, package_name, server_config)
    self.lsp_packages[package_name] = server_config
    table.insert(self.ensure_installed_packages, package_name)
  end,

  ---@param package_name string
  add_extra_mason_package = function(self, package_name) table.insert(self.ensure_installed_packages, package_name) end,

  lsp_packages = {},
  ensure_installed_packages = {},
}

local package_manager = PackageManager

local get_package_name = function(package_file_path) return package_file_path:match '([^/]+)%.lua$' end

---@param dir string
---@return string[]
local function scan_package_files(dir) return vim.fn.glob(vim.fn.stdpath 'config' .. '/autoload/' .. dir .. '/*.lua', true, true) end

local function is_lua_file(file_path) return file_path:sub(-4) == '.lua' end

---@return nil
local function load_files()
  local lsp_files = scan_package_files 'lsp'

  for _, config_file_path in pairs(lsp_files) do
    if is_lua_file(config_file_path) == 1 then goto continue end

    local server_name = get_package_name(config_file_path)

    package_manager:add_lsp_package(server_name, dofile(config_file_path))

    ::continue::
  end

  local mason_files = scan_package_files 'mason'

  for _, config_file_path in pairs(mason_files) do
    if is_lua_file(config_file_path) == 1 then goto continue end

    local package_name = get_package_name(config_file_path)

    package_manager:add_extra_mason_package(package_name)

    ::continue::
  end
end

local function config_and_install_lsp_packages()
  local capabilities = require('blink.cmp').get_lsp_capabilities()

  for server_name, server_config in pairs(package_manager.lsp_packages) do
    server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})

    vim.lsp.config(server_name, server_config)
    vim.lsp.enable(server_name)
  end
end

load_files()

require('mason-tool-installer').setup {
  ensure_installed = package_manager.ensure_installed_packages,
}
config_and_install_lsp_packages()
