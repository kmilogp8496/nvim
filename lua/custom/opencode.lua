local M = {}

M.last_prompt = nil
M.last_model = nil
M.last_variant = nil

M.config = {
  default_variant = 'simple',
  variants = {
    simple = {
      model = 'openai/gpt-5.1-codex-mini',
      template = function(ctx)
        return table.concat({
          'Task: ' .. (ctx.input or ''),
          '',
          'Context:',
          '- file: ' .. (ctx.file or ''),
          '- line: ' .. tostring(ctx.line or ''),
        }, '\n')
      end,
    },
    complex = {
      model = 'openai/gpt-5.2-codex',
      template = function(ctx)
        return table.concat({
          'Task: ' .. (ctx.input or ''),
          '',
          'Context:',
          '- file: ' .. (ctx.file or ''),
          '- line: ' .. tostring(ctx.line or ''),
          '- col: ' .. tostring(ctx.col or ''),
          '- filetype: ' .. (ctx.filetype or ''),
          '- line_text: ' .. (ctx.line_text or ''),
        }, '\n')
      end,
    },
  },
}

local function get_line_text(bufnr, line)
  local lines = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)
  return lines[1] or ''
end

function M.get_context()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local file = vim.fn.expand '%:p'
  if file == '' then
    file = '[No Name]'
  else
    file = vim.fn.fnamemodify(file, ':.')
  end

  return {
    bufnr = bufnr,
    line = cursor[1],
    col = cursor[2] + 1,
    file = file,
    filetype = vim.bo[bufnr].filetype,
    line_text = get_line_text(bufnr, cursor[1]),
  }
end

function M.build_prompt(ctx, variant)
  local name = variant or M.config.default_variant
  local spec = M.config.variants[name]
  if not spec then error('opencode.build_prompt unknown variant: ' .. tostring(name)) end
  return spec.template(ctx)
end

local function create_prompt_window()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = 'prompt'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false

  local win_width = vim.api.nvim_win_get_width(0)
  local width = math.min(80, math.max(40, win_width - 4))

  local row = -1
  if vim.fn.line '.' <= 1 then row = 0 end

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'cursor',
    row = row,
    col = 0,
    width = width,
    height = 1,
    style = 'minimal',
    border = 'rounded',
  })

  return buf, win
end

function M.open_prompt(variant, cb)
  if type(variant) == 'function' and cb == nil then
    cb = variant
    variant = nil
  end

  if type(cb) ~= 'function' then error 'opencode.open_prompt expects a callback function' end

  local ctx = M.get_context()
  local buf, win = create_prompt_window()

  local function close_prompt()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
  end

  vim.fn.prompt_setprompt(buf, 'Opencode: ')

  vim.keymap.set('i', '<C-c>', close_prompt, { buffer = buf, silent = true })
  vim.keymap.set('n', '<Esc>', close_prompt, { buffer = buf, silent = true })

  vim.fn.prompt_setcallback(buf, function(input)
    local prompt = M.build_prompt(vim.tbl_extend('force', ctx, { input = input or '' }), variant)
    local name = variant or M.config.default_variant
    local spec = M.config.variants[name] or {}
    local model = spec.model

    M.last_prompt = prompt
    M.last_model = model
    M.last_variant = name

    cb(prompt, model, name)
    close_prompt()
  end)

  vim.fn.prompt_setinterrupt(buf, function() close_prompt() end)

  vim.cmd 'startinsert'
end

return M
