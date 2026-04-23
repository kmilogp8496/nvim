return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function() require('conform').format { async = true, lsp_format = 'fallback' } end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      local ft = vim.bo[bufnr].filetype
      local bufname = vim.api.nvim_buf_get_name(bufnr)

      if ft == 'yaml' and bufname:match '/essa%-puppet/' then return nil end

      if disable_filetypes[ft] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      markdown = { 'oxfmt' },
      typescript = { 'oxfmt' },
      javascript = { 'oxfmt' },
      vue = { 'oxfmt' },
      json = { 'oxfmt' },
      php = { 'php_cs_fixer' },
    },
  },
}
