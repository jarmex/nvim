return {
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>hd", "<cmd>Hardtime disable<cr>", desc = "HardTime Disable" },
    { "<leader>he", "<cmd>Hardtime enable<cr>",  desc = "HardTime Enable" },
  },
  opts = {
    allow_different_key = true,
    disabled_filetypes = {
      "Diffview*",
      "Dressing*",
      "Neogit*",
      "NvimTree",
      "ToggleTerm",
      "alpha",
      "checkhealth",
      "dapui*",
      "help",
      "httpResult",
      "lazy",
      "lspinfo",
      "mason",
      "neotest-summary",
      "netrw",
      "netrw",
      "noice",
      "notify",
      "oil",
      "prompt",
      "qf",
      "undotree",
      "trouble",
      "Outline"
    },
    hints = {
      ["[dcyvV][ia]%("] = {
        message = function(keys)
          return "Use " .. keys:sub(1, 2) .. "b instead of " .. keys
        end,
        length = 3,
      },
    },
  },
}
