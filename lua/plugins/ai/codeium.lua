-- local function codeium_keymaps()
--   local function local_map(key, func, desc, mode)
--     if not mode then
--       mode = 'i'
--     end
--     return { key, func, mode = mode, expr = true, silent = true, desc = desc }
--   end
--   return {
-- 		-- stylua: ignore start
--     local_map("<C-cr>", function() return vim.fn["codeium#Accept"]() end, "󰚩 Accept Suggestion"),
--     local_map("<c-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, "󰚩 Cycle Suggestion"),
--     local_map("<c-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, "󰚩 Cycle Suggestion"),
--     local_map("<c-x>", function() return vim.fn["codeium#Clear"]() end, "󰚩 Clear Suggestion"),
--     -- local_map("<leader>cd", function() return vim.fn["codeium#Chat"]() end, "󰚩 Chat", "n"),
--     -- stylua: ignore end
--   }
-- end

return {
  -- {
  --   'Exafunction/codeium.vim',
  --   event = 'InsertEnter',
  --   keys = codeium_keymaps(),
  --   config = function()
  --     vim.g.codeium_filetypes = {
  --       TelescopePrompt = false,
  --       DressingInput = false,
  --     }
  --     vim.g.codeium_disable_bindings = 1
  --   end,
  -- },
  { ---@type LazyPluginSpec
    'Exafunction/windsurf.nvim',
    enabled = false,
    event = 'VeryLazy',
    name = 'codeium.nvim',
    opts = {
      enable_chat = true,
      enable_cmp_source = false,
      enable_local_search = true,
      enable_index_service = true,
      virtual_text = {
        enabled = true,
        -- Set to true if you never want completions to be shown automatically.
        manual = false,
        idle_delay = 50,
        filetypes = {
          help = false,
          gitcommit = false,
          codecompanion = false,
          TelescopePrompt = false,
          gitrebase = false,
          DressingInput = false,
          bigfile = false,
          snacks_picker_input = false,
          ['.'] = false,
        },
        default_filetype_enabled = true,
        map_keys = true,
        key_bindings = {
          accept = '<c-;>',
          accept_word = '<c-o>',
          accept_line = '<c-l>',
          clear = "<c-'>",
          next = '<c-.>',
          prev = '<c-,>',
        },
      },
    },
    config = function(_, opt)
      require('codeium').setup(opt)
      -- vim.keymap.set('n', '<leader>cc', '<cmd>Codeium Chat<cr>', { desc = 'Codeium' })
      -- hl CodeiumSuggestion
    end,
  },
}
