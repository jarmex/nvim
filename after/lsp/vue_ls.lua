---@type vim.lsp.Config
local config = {
  filetypes = { 'vue' },
  init_options = {
    vue = { hybridMode = true },
  },
  settings = {
    vue = {
      complete = {
        casing = {
          tags = 'kebab',
          props = 'kebab',
        },
      },
    },
  },
}

return config
