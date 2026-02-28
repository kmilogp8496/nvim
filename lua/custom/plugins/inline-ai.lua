return {
  'kmilogp/inline-ai.nvim',
  opts = {
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
  },
}
