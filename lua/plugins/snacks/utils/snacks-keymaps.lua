return function()
   -- stylua: ignore
  return {
    -- { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer', },
    {
			'<leader>.',
			function()
				vim.ui.input({
					prompt = 'Enter filetype for the scratch buffer: ',
					default = 'markdown',
					completion = 'filetype',
				}, function(ft)
					require('snacks').scratch.open {
						ft = ft,
						win = {
							width = 200,
							height = 100,
							title = 'Scratch Buffer',
						},
					}
				end)
			end,
			{ desc = 'Toggle Scratch Buffer' },
		},
    {
			'<leader>lt',
			function()
				local git_root = vim.fs.root(0, '.git')
				if git_root then
					local file = git_root .. '/todo.md'
					require('snacks').scratch.open {
						ft = 'markdown',
						file = file,
					}
				end
			end,
			desc = 'Toggle Scratch Todo',
		},
    { '<leader>st', function() Snacks.scratch({ icon = ' ', name = 'Todo', ft = 'markdown', file = 'scratch-file.md' }) end, desc = 'Todo List', },
    { '<leader>S', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer', },
    { '<leader>ns', function() Snacks.notifier.show_history() end, desc = 'Notification History', },
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer', },
    { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse', },
    { '<leader>gb', function() Snacks.git.blame_line() end, desc = 'Git Blame Line', },
    { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'Lazygit Current File History', },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit', },
    { '<leader>gl', function() Snacks.lazygit.log() end, desc = 'Lazygit Log (cwd)', },
    { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications', },
    -- { "<c-i>",     function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { 'TT', function() Snacks.terminal() end, desc = 'Toggle Terminal', },
    { ']r', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' }, },
    { '[r', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' }, },
    { '<leader>/',
      function()
        ---@class snacks.picker.grep.Config: snacks.picker.proc.Config
        local opts = {
          hidden = false, -- do not include hidden files
          ignored = false, -- true = include files from .gitignore
          exclude = { '*.pb.go', '.venv/*', '.mypy_cache/*', '.repro/*', 'node_modules/*' },
        }
        Snacks.picker.grep(opts)
      end,
      desc = 'Grep',
    },
    { '<leader>bg', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers', },
    { '<leader>sh', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' }, },
    { "<leader>iv", function() require("snacks").picker.help() end, desc = "󰋖 Vim help" },
    { "<leader>ik", function() require("snacks").picker.keymaps() end, desc = "󰌌 Keymaps (global)" },
    -- stylua: ignore end
		{
			"<leader>iK",
			function()
				require("snacks").picker.keymaps { global = false, title = "󰌌 Keymaps (buffer)" }
			end,
			desc = "󰌌 Keymaps (buffer)",
		},
    { '<leader>rr', function() Snacks.picker.resume() end, desc = 'Resume', },
    { '<leader>je', function() Snacks.picker.explorer() end, desc = 'Explorer', },
    { '<leader>ff', function() Snacks.picker.smart({ filter = { cwd = true } }) end, desc = 'Find Files', },
    { '<leader>bb', function() Snacks.picker.buffers({ layout = { preset = 'select' } }) end, desc = 'Buffers', },
    { '<leader>sp', function() Snacks.picker({ layout = { preset = 'vscode' } }) end, desc = 'Pickers', },
    { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History', },
    { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines', },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History', },
    { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks', },
    { '<leader>fe',
      function()
        local buf_path = vim.api.nvim_buf_get_name(0)
        local dir = vim.fn.fnamemodify(buf_path, ':h')

        Snacks.picker.files({
          cwd = dir,
          hidden = false,
          ignored = false,
        })
      end,
      desc = 'Find files in current directory',
    },
    { '<leader>sl', function() require('plugins.snacks.utils.picker-helper').neovim_logs() end, desc = '[s]earch [l]ogs', },
     -- git
      { "<leader>gdp", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
      { "<leader>gdo", function() Snacks.picker.git_diff({ base = "origin", group = true }) end, desc = "Git Diff (origin)" },
      { "<leader>gds", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gdi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>gdI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      { "<leader>gdr", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { "<leader>gdP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
  }
end
