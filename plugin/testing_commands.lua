---@param filename string
---@return string | nil
local function extract_test_from_service(filename)
  local content = vim.fn.readfile(filename)

  for _, line in ipairs(content) do
    local match = line:match '#%[Behaviour%(([^%)]+)%)%]'
    if match then return match:gsub('"', ''):gsub("'", '') end
  end

  return filename:gsub('.php$', '.feature'):gsub('Service/', 'test/Behaviour/'):gsub('.php$', '.feature'):gsub('UseCase/', 'test/Behaviour/')
end

local commands = {
  ['php-behaviour'] = { 'composer', 'test-behaviour' },
  ['php-unit'] = { 'composer', 'test-unit' },
  ['pnpm-test'] = { 'pnpm', 'run', 'test' },
}

local test_ending_commands = {
  ['Test.php'] = { cmd = commands['php-unit'] },
  ['Context.php'] = {
    cmd = commands['php-behaviour'],
    ---@param filename string
    refine_file = function(filename) return filename:gsub('Context.php$', '.feature'):gsub('Context/', '') end,
  },
  ['UseCase.php'] = {
    cmd = commands['php-behaviour'],
    refine_file = extract_test_from_service,
  },
  ['Service.php'] = {
    cmd = commands['php-behaviour'],
    refine_file = extract_test_from_service,
  },
  ['.feature'] = { cmd = commands['php-behaviour'] },
  ['.test.ts'] = { cmd = commands['pnpm-test'] },
  ['.test.js'] = { cmd = commands['pnpm-test'] },
  ['.spec.ts'] = { cmd = commands['pnpm-test'] },
  ['.spec.js'] = { cmd = commands['pnpm-test'] },
}

---@param filename string
---@return string[]|nil
local function get_test_command(filename)
  for ending, command in pairs(test_ending_commands) do
    if filename:sub(-#ending) == ending then
      if command.refine_file then
        local refined_filename = command.refine_file(filename)

        if nil == refined_filename then
          vim.notify('Could not extract test name from file: ' .. filename, vim.log.levels.ERROR)
          return nil
        end

        filename = refined_filename
      end
      return vim.list_extend(vim.deepcopy(command.cmd), { filename })
    end
  end

  return nil
end

vim.api.nvim_create_user_command('RunFileTest', function(input)
  local files = vim.split(input.args, ' ')
  for _, file in ipairs(files) do
    local command = get_test_command(file)
    if not command then
      vim.notify('No test command found for file: ' .. file, vim.log.levels.WARN)
      goto continue
    end

    vim.system(command, { text = true }, function(res)
      local notification_options = { title = table.concat(command, ' '), timeout = 5000 }
      vim.schedule(function()
        if res.code ~= 0 then
          vim.notify(res.stderr ~= '' and (res.stdout or '') .. res.stderr or ('exit code: ' .. res.code), vim.log.levels.ERROR, notification_options)
        else
          vim.notify(res.stdout, vim.log.levels.INFO, notification_options)
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

vim.keymap.set({ 'n', 'v' }, '<leader>rt', '<Cmd>RunFileTest %<Cr>', {
  desc = '[R]un [T]ests for current file',
})
