-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "vue" },
  callback = function()
    vim.b.autoformat = false
  end,
})

local customizations = {
  { rule = "style/*", severity = "off", fixable = true },
  { rule = "format/*", severity = "off", fixable = true },
  { rule = "*-indent", severity = "off", fixable = true },
  { rule = "*-spacing", severity = "off", fixable = true },
  { rule = "*-spaces", severity = "off", fixable = true },
  { rule = "*-order", severity = "off", fixable = true },
  { rule = "*-dangle", severity = "off", fixable = true },
  { rule = "*-newline", severity = "off", fixable = true },
  { rule = "*quotes", severity = "off", fixable = true },
  { rule = "*semi", severity = "off", fixable = true },
}

local lspconfig = require("lspconfig")
-- Enable eslint for all supported languages
lspconfig.eslint.setup({
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "html",
    "markdown",
    "json",
    "jsonc",
    "yaml",
    "toml",
    "xml",
    "gql",
    "graphql",
    "astro",
    "svelte",
    "css",
    "less",
    "scss",
    "pcss",
    "postcss",
  },
  settings = {
    -- Silent the stylistic rules in you IDE, but still auto fix them
    rulesCustomizations = customizations,
  },
})

lspconfig.eslint.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})
