--  ╭─────────────────╮
--  │ Default plugins │
--  ╰─────────────────╯
---  SETTINGS  ---
local default_options = {
	backspace = { "indent", "eol", "start" },
	backup = false, -- creates a backup file
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	cmdheight = 0, -- more space in the neovim command line for displaying messages
	colorcolumn = "99999", -- fixes indentline for now
	completeopt = { "menuone", "noselect" },
	conceallevel = 0, -- so that `` is visible in markdown files
	fileencoding = "utf-8", -- the encoding written to a file
	foldenable = true, -- Enable folding
	foldlevel = 99, -- Fold by default, -- Using ufo provider need a large value, feel free to decrease the value
	foldmethod = "expr", -- folding, set to "expr" for treesitter based folding
	foldexpr = "", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
	foldlevelstart = 99,
	foldcolumn = "1",
	hidden = true, -- required to keep multiple buffers and open multiple buffers
	hlsearch = true, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	mouse = "a", -- allow the mouse to be used in neovim
	pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore (dont show mode since we have a statusline)
	showtabline = 2, -- always show tabs
	smartcase = true, -- smart case
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	termguicolors = true, -- set term gui colors (most terminals support this)
	timeout = true, -- This option and 'timeoutlen' determine the behavior when part of a mapped key sequence has been received. This is on by default but being explicit!
	timeoutlen = 500, -- Time in milliseconds to wait for a mapped sequence to complete.
	ttimeoutlen = 10, -- Time in milliseconds to wait for a key code sequence to complete
	updatetime = 280, -- If in this many milliseconds nothing is typed, the swap file will be written to disk. Also used for CursorHold autocommand (JARMEX = 300)
	wildignore = { "*/.git/*", "*/node_modules/*" }, -- Ignore these files/folders
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
	cursorline = true, -- highlight the current line
	number = true, -- set numbered lines
	laststatus = 3,
	relativenumber = true, -- set relative numbered lines
	numberwidth = 2, -- set number column width to 2 {default 4}
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	wrap = false, -- display lines as one long line
	spell = false,
	spelllang = "en",
	scrolloff = 4,
	sidescrolloff = 4,
	encoding = "UTF-8", -- Set the encoding type
	incsearch = true, -- Shows the match while typing
	shiftround = true, -- Round indent
	fillchars = {
		foldopen = "",
		foldclose = "",
		fold = " ",
		foldsep = " ",
		diff = "╱",
		eob = " ",
	},
}

vim.cmd([[set iskeyword+=-]])
for k, v in pairs(default_options) do
	vim.opt[k] = v
end

-- vim.cmd([[ filetype indent plugin on syntax enable ]])

-- Stop loading built in plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.wo.colorcolumn = "99999"

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
    end,
})
-- call the function
