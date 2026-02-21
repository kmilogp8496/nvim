---@param cmd string
---@param args string
local function validate_php_move_args(cmd, args)
  local parts = vim.split(args, ' ')
  if #parts < 2 then return false, { 'Usage: ', cmd .. ' <from> <to>' } end
  return true, parts
end

---@param src string
---@param dest string
local function move_php_file(src, dest)
  local cmd = string.format('phpactor class:move %s %s --no-interaction', src, dest)
  return vim.fn.system(cmd, '')
end

local function move_file(src, dest)
  local dest_dir = vim.fn.fnamemodify(dest, ':h')
  vim.fn.mkdir(dest_dir, 'p')
  vim.fn.rename(src, dest)
  return 'Moved non-PHP file from ' .. src .. ' to ' .. dest
end

vim.api.nvim_create_user_command('PhpMove', function(input)
  local validation_result, parts = validate_php_move_args('PhpMove', input.args)

  if validation_result == 0 then
    print(table.concat(parts, '\n'))
    return
  end

  local result = move_php_file(parts[1], parts[2])

  print(result)
end, { nargs = '+', complete = 'file' })

vim.api.nvim_create_user_command('PhpMoveDir', function(input)
  local validation_result, parts = validate_php_move_args('PhpMove', input.args)

  if validation_result == 0 then
    print(table.concat(parts, '\n'))
    return
  end

  local from = parts[1]
  local to = parts[2]

  if from:sub(-1) == '/' then from = from:sub(1, -2) end

  if to:sub(-1) == '/' then to = to:sub(1, -2) end

  local files = vim.fs.find(function() return true end, { path = from, type = 'file', limit = math.huge })

  for _, file in ipairs(files) do
    local relative_path = file:sub(#from + 2)
    local destination = to .. '/' .. relative_path

    local result = ''

    if 'php' == vim.fn.fnamemodify(file, ':e') then
      result = move_php_file(file, destination)
    else
      result = move_file(file, destination)
    end

    print(result)
  end
end, { nargs = '+', complete = 'file' })

---@param filename string
local function setup_php_file(filename)
  local cmd = string.format('phpactor class:transform %s --transform=fix_namespace_class_name', filename)
  return vim.fn.system(cmd, '')
end

vim.api.nvim_create_user_command('PhpSetupFile', function(input)
  local filename = input.args
  if filename == '' then filename = vim.api.nvim_buf_get_name(0) end
  local result = setup_php_file(filename)
  print(result)
end, { nargs = 1, complete = 'file' })

-- phpactor class:new path/To/ClassName.php
vim.api.nvim_create_user_command('PhpCreateClass', function(input)
  local filename = input.args
  if filename == '' then
    print 'Usage: PhpCreateClass <path/to/ClassName.php>'
    return
  end
  local cmd = string.format('phpactor class:new %s --no-interaction', filename)
  local result = vim.fn.system(cmd, '')
  print(result)
end, { nargs = 1, complete = 'file' })
