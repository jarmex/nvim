return {
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function(_, opts)
      if opts then
        require('luasnip').config.setup(opts)
      end

      require('luasnip.loaders.from_vscode').lazy_load()

      require('plugins.coding.luasnip.localsnip')

      local ls = require('luasnip')
      local types = require('luasnip.util.types')
      ls.config.set_config({
        ext_opts = {
          [types.choiceNode] = {
            active = { virt_text = { { 'choiceNode', 'IncSearch' } } },
          },
          [types.insertNode] = { passive = { hl_group = 'Substitute' } },
          [types.exitNode] = { passive = { hl_group = 'Substitute' } },
        },
        updateevents = 'TextChanged,TextChangedI',
        store_selection_keys = '<c-j>',
      })
      vim.cmd([[
                imap <silent><expr> <c-j> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-j>'
                imap <silent><expr> <c-k>  luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev': '<c-k>'
                imap <silent><expr> <c-e> luasnip#choice_active() ? '<Plug>luasnip-next-choice': '<c-e>'
                snoremap <silent> <c-j> <cmd>lua require'luasnip'.jump(1)<Cr>
                snoremap <silent> <c-k> <cmd>lua require'luasnip'.jump(-1)<Cr>
                vnoremap <c-f>  \"ec<cmd>lua require('luasnip.extras.otf').on_the_fly()<cr>
                inoremap <c-f>  <cmd>lua require('luasnip.extras.otf').on_the_fly('e')<cr>
            ]])
      require('luasnip').filetype_extend('typescript', { 'tsdoc' })
      require('luasnip').filetype_extend('typescript', { 'next-ts' })
      require('luasnip').filetype_extend('javascript', { 'jsdoc' })
      require('luasnip').filetype_extend('javascript', { 'next' })
      require('luasnip').filetype_extend('lua', { 'luadoc' })
      require('luasnip').filetype_extend('python', { 'pydoc' })
      require('luasnip').filetype_extend('rust', { 'rustdoc' })
      require('luasnip').filetype_extend('cs', { 'csharpdoc' })
      require('luasnip').filetype_extend('java', { 'javadoc' })
      require('luasnip').filetype_extend('c', { 'cdoc' })
      require('luasnip').filetype_extend('cpp', { 'cppdoc' })
      require('luasnip').filetype_extend('php', { 'phpdoc' })
      require('luasnip').filetype_extend('kotlin', { 'kdoc' })
      require('luasnip').filetype_extend('ruby', { 'rdoc' })
      require('luasnip').filetype_extend('sh', { 'shelldoc' })
    end,
  },
}
