local M = {}

function M.keymaps()
  return {
    { '<leader>t', '', desc = '+test' },
    {
      '<leader>tn',
      "<cmd>lua require('neotest').run.run()<cr>",
      desc = 'Run nearest test',
    },
    {
      '<leader>tT',
      function()
        require('neotest').run.run(vim.uv.cwd())
      end,
      desc = 'Run All Test Files',
    },
    {
      '<leader>tl',
      function()
        require('neotest').run.run_last()
      end,
      desc = 'Run last test',
    },
    {
      '<leader>tf',
      function()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
      desc = 'Run test file',
    },
    {
      '<leader>td',
      function()
        require('neotest').run.run({ strategy = 'dap' })
      end,
      desc = 'Debug test',
    },
    {
      '<leader>tD',
      "w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
      desc = 'Debug File',
    },
    {
      '<leader>ta',
      "<cmd>lua require('neotest').run.attach()<cr>",
      desc = 'Attach test',
    },
    {
      '<leader>tc',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle Summary',
    },
    {
      '<leader>ts',
      function()
        if vim.bo.filetype == 'lua' then
          return require('mini.test').run() -- Not configured yet
        end
        local neotest = require('neotest')
        for _, adapter_id in ipairs(neotest.run.adapters()) do
          neotest.run.run({ suite = true, adapter = adapter_id })
        end
      end,
      desc = 'Neotest: Test suite',
    },
    {
      '<leader>tx',
      "<cmd>lua require('neotest').stop()<cr>",
      desc = 'Stop test',
    },
    {
      '<leader>to',
      function()
        require('neotest').output.open({ enter = true, auto_close = true, short = true })
      end,
      desc = 'Open output test',
    },
    {
      '<leader>tO',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Output test panel',
    },
    {
      '<leader>tt',
      function()
        require('neotest').summary.open()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
      desc = 'Neotest toggle',
    },
    {
      '<leader>twn',
      function()
        require('neotest').watch.toggle()
      end,
      desc = 'Neotest: Watch nearest test',
    },
    {
      '<leader>twf',
      function()
        require('neotest').watch.toggle(vim.fn.expand('%'))
      end,
      desc = 'Toggle Watch',
    },
    {
      '<leader>twa',
      function()
        require('neotest').watch.toggle({ suite = true })
      end,
      desc = 'Neotest: Watch all tests',
    },
    {
      ']e',
      function()
        require('neotest').jump.next({ status = 'failed' })
      end,
      desc = 'Next Failed Test',
    },
    {
      '[e',
      function()
        require('neotest').jump.prev({ status = 'failed' })
      end,
      desc = 'Previous Failed Test',
    },
  }
end

return M

--   keys = {
--     { "<leader>tn", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test", },
--     { "<leader>tN", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files", },
--     { "]e", function() require("neotest").jump.next() end,  desc = "Next Test", },
--     { "[e", function() require("neotest").jump.prev() end,  desc = "Previous Test", },
--     { "<leader>tl", function() require('neotest').run.run_last() end , desc = "Run last test", },
--     { "<leader>tf", function() require('neotest').run.run(vim.fn.expand("%")) end , desc = "Run test file", },
--     { "<leader>td", function() require("neotest").run.run({ suite = false, strategy = "dap" }) end, desc = "Debug test", },
--     { "<leader>tD", "w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = "Debug File", },
--     { "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach test", },
--     { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary", },
--     { "<leader>tx", "<cmd>lua require('neotest').stop()<cr>", desc = "Stop test", },
--     { "<leader>to", function() require('neotest').output.open({enter = true, auto_close = true}) end, desc = "Open output test", },
--     { "<leader>tO", function() require('neotest').output_panel.toggle() end, desc = "Output test panel", },
--     { "<leader>tt", function() require("neotest").summary.open() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Neotest toggle", },
--   },
