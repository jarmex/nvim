return {
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPre",
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft
      require("lint").linters_by_ft = {
        python = { "ruff" },
        htmldjango = { "djlint" },
        lua = { "selene", "luacheck" },
        typescript = { "biomejs", "eslint_d", "eslint" },
        javascript = { "biomejs", "eslint_d", "eslint" },
        typescriptreact = { "biomejs", "eslint_d", "eslint" },
        javascriptreact = { "biomejs", "eslint_d", "eslint" },
        svelte = { "eslint_d" },
        sql = { "sqlfluff" },
      }

      vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost", "BufReadPost" }, {
        callback = function()
          local lint_status, lint = pcall(require, "lint")
          if lint_status then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
