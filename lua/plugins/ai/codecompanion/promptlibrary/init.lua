local prompt_library = {
  markdown = {
    dirs = {
      vim.fn.getcwd() .. '/.prompts',
      vim.fn.stdpath('config') .. '/prompts',
    },
  },
}

return vim.tbl_extend(
  'force',
  {},
  prompt_library,
  (require('plugins.ai.codecompanion.promptlibrary.others')),
  (require('plugins.ai.codecompanion.promptlibrary.cli_prompt'))
)
