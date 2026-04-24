---@type (string | LazySpec)[]
return {
  {
    'dmmulroy/ts-error-translator.nvim',
    event = 'VeryLazy',
    opts = {
      auto_attach = true,
      servers = {
        'astro',
        'svelte',
        'ts_ls',
        'volar',
        'vtsls',
      },
    },
  },
  {
    'davidosomething/format-ts-errors.nvim',
    config = function()
      require('format-ts-errors').setup({
        add_markdown = true, -- wrap output with markdown ```ts ``` markers
        start_indent_level = 0, -- initial indent
      })
    end,
  },
}
