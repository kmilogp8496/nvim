return {
  -- LSP settings
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = true,
        exclude = { "vue", "typescript" }, -- filetypes for which you don't want to enable inlay hints
      },
    },
  },
}
