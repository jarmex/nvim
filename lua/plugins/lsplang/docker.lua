return {
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    opts = {
      servers = {
        -- https://github.com/rcjsuen/dockerfile-language-server
        dockerls = {
          filetypes = { 'dockerfile' },
        },
      },
    },
  },
}
