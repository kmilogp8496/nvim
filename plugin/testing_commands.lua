local test_ending_commands = {
  ['Test.php'] = { 'composer', 'test-unit' },
  ['.feature'] = { 'composer', 'test-behavior' },
  ['.test.ts'] = { 'pnpm', 'run', 'test' },
  ['.test.js'] = { 'pnpm', 'run', 'test' },
  ['.spec.ts'] = { 'pnpm', 'run', 'test' },
  ['.spec.js'] = { 'pnpm', 'run', 'test' },
}

---@param filename string
---@return string[]|nil
local function get_test_command(filename)
  for ending, command in pairs(test_ending_commands) do
    if filename:sub(-#ending) == ending then
      table.insert(command, filename)
      return command
    end
  end

  return nil
end

pcall(function() vim.api.nvim_del_user_command 'RunFileTest' end)

vim.api.nvim_create_user_command('RunFileTest', function(input)
  local files = vim.split(input.args, ' ')
  for _, file in ipairs(files) do
    local command = get_test_command(file)
    if not command then
      print('No test command found for file: ' .. file)
      goto continue
    end

    vim.system(command, { text = true }, function(res)
      vim.schedule(function()
        if res.code ~= 0 then
          vim.notify(res.stderr ~= '' and res.stderr or ('exit code: ' .. res.code), vim.log.levels.ERROR)
        else
          vim.notify(res.stdout, vim.log.levels.INFO)
        end
      end)
    end)

    ::continue::
  end
end, {
  desc = 'Run tests for the given file(s)',
  nargs = '+',
  complete = 'file',
})
