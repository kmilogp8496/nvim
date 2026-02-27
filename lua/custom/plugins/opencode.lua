return {
  'git@github.com:kmilogp/opencode.nvim',
  opts = {
    default_profile = 'fast',
    profiles = {
      fast = {
        provider = 'cursor_agent',
        model = 'composer-1.5',
      },
      deep = {
        provider = 'cursor_agent',
        model = 'Opus 4.6',
      },
    },
  },
}
