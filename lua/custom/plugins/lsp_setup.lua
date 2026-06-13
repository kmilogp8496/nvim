local package_manager = {
  lsp_packages = {},
  ensure_installed_packages = {},
}

---@param package_name string
---@param server_config table
function package_manager:add_lsp_package(package_name, server_config)
  self.lsp_packages[package_name] = server_config
  table.insert(self.ensure_installed_packages, package_name)
end

---@param package_name string
function package_manager:add_extra_mason_package(package_name)
  table.insert(self.ensure_installed_packages, package_name)
end

---@param package_file_path string
---@return string
local function get_package_name(package_file_path) return package_file_path:match '([^/]+)%.lua$' end

---@param dir string
---@return string[]
local function scan_package_files(dir) return vim.fn.glob(vim.fn.stdpath 'config' .. '/autoload/' .. dir .. '/*.lua', true, true) end

local function load_files()
  local lsp_files = scan_package_files 'lsp'
  for _, config_file_path in ipairs(lsp_files) do
    package_manager:add_lsp_package(get_package_name(config_file_path), dofile(config_file_path))
  end

  local mason_files = scan_package_files 'mason'
  for _, config_file_path in ipairs(mason_files) do
    package_manager:add_extra_mason_package(get_package_name(config_file_path))
  end
end

load_files()

local has_mason_tool_installer, mason_tool_installer = pcall(require, 'mason-tool-installer')
if has_mason_tool_installer then
  mason_tool_installer.setup {
    ensure_installed = package_manager.ensure_installed_packages,
  }
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_blink, blink = pcall(require, 'blink.cmp')
if has_blink then capabilities = blink.get_lsp_capabilities(capabilities) end

for server_name, server_config in pairs(package_manager.lsp_packages) do
  server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})
  vim.lsp.config(server_name, server_config)
  vim.lsp.enable(server_name)
end
