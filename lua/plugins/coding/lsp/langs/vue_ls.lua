return {
  cmd = { 'vls' },
  filetypes = { 'vue' },
  init_options = {
    typescript = {
      tsdk = vim.fn.expand('$MASON/packages/vue-language-server/node_modules/typescript/lib'),
    },
  },
}
