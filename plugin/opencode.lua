local opencode = require 'custom.opencode'

vim.api.nvim_create_user_command('OpencodePrompt', function(opts)
  local variant = opts.args ~= '' and opts.args or nil
  opencode.open_prompt(variant, function(prompt, model, name)
    local label = name or opencode.config.default_variant
    local model_info = model and ('model: ' .. model) or 'model: <unset>'
    vim.notify('Opencode prompt built (' .. label .. ', ' .. model_info .. '):\n' .. prompt, vim.log.levels.INFO)
  end)
end, {
  desc = 'Open floating input to build Opencode prompt',
  nargs = '?',
  complete = function() return vim.tbl_keys(opencode.config.variants) end,
})

vim.keymap.set('n', '<leader>o', function()
  opencode.open_prompt('simple', function(prompt, model, name)
    local model_info = model and ('model: ' .. model) or 'model: <unset>'
    vim.notify('Opencode prompt built (' .. name .. ', ' .. model_info .. '):\n' .. prompt, vim.log.levels.INFO)
  end)
end, { desc = 'Open Opencode simple prompt' })

vim.keymap.set('n', '<leader>O', function()
  opencode.open_prompt('complex', function(prompt, model, name)
    local model_info = model and ('model: ' .. model) or 'model: <unset>'
    vim.notify('Opencode prompt built (' .. name .. ', ' .. model_info .. '):\n' .. prompt, vim.log.levels.INFO)
  end)
end, { desc = 'Open Opencode complex prompt' })
