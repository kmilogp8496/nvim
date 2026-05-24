vim.pack.add {
  'https://github.com/kmilogp/inline-ai.nvim',
}

local ok, inline_ai = pcall(require, 'inline_ai')
if not ok then return end

inline_ai.setup {
  default_profile = 'fast',
  profiles = {
    fast = {
      provider = 'ollama',
      model = 'qwen2.5-coder:14b',
    },
    deep = {
      provider = 'cursor_agent',
      model = 'Opus 4.6',
    },
  },
}
