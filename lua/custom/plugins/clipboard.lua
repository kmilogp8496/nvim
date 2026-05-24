local function is_wsl()
  if vim.fn.has 'wsl' == 1 then return true end

  local ok, uname = pcall(vim.loop.os_uname)
  if ok and uname and uname.release then return uname.release:lower():find 'microsoft' ~= nil end

  return false
end

if is_wsl() and vim.fn.executable 'win32yank.exe' == 1 then
  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
  vim.opt.clipboard = 'unnamedplus'
end
