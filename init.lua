-- Configuration (Built from https://dev.to/vonheikemen/build-your-first-neovim-configuration-in-lua-177b)
-- QOL
vim.o.autowrite = true
vim.o.number = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.g.mapleader = " "
-- netrw
vim.g.netrw_winsize = 30
vim.o.autochdir = false

-- Configure Git Bash
vim.o.shell = 'bash.exe'
vim.o.shellcmdflag = '-c'
vim.o.shellquote = ''
vim.o.shellxquote = ''

-- Binding utils
--- CD's window to parent dir of file or dir
function cd_with_strip(str)
	local dir = string.gsub(str, "(.*)/.-$", "%1")
	return vim.fn.chdir(dir, "global")
end

-- Bindings
--- Basic
vim.keymap.set({'n', 'x'}, 'gy', '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({'n', 'x'}, 'gp', '"+p', { desc = "Paste from clipboard" })
vim.keymap.set({'n', 'x'}, 'x', '"_x', { desc = "Don't write to register on delete" })
vim.keymap.set({'n', 'x'}, 'X', '"_d')
vim.keymap.set({'n', 'x'}, 'gt', '<cmd>leftabove vsplit ~/<cr><cmd>term<cr>', { desc = "Open term left" })
vim.keymap.set(
	{'n', 'x'},
	'gc',
	function()
		local buf_dir = string.gsub(vim.fn.expand("%:p"), "\\", "/")
		local prev = cd_with_strip(buf_dir)
		print("Switched from dir " .. prev .. " to dir " .. buf_dir)
	end,
	{ desc = "Switch window directory to directory of file / directory in buffer" }
)
vim.keymap.set(
	{'n', 'x'},
	'gr',
	function()
		local buf_dir = string.gsub(vim.fn.expand("%:p"), "\\", "/")
		local prev = cd_with_strip(buf_dir)
		local result_table, result = vim.system({"git", "rev-parse", "--show-toplevel"}, { text = true }):wait(), ""
		if result_table.code ~= 0 then
			print("No top level dir found. git rev-parse --show-toplevel result: " .. result_table.stderr)
			return
		else
			result = string.gsub(result_table.stdout, "\\n$", "/")
		end
		cd_with_strip(result)
		print("Switched to " .. result .. " from " .. prev)
	end,
	{ desc = "Changes global dir to git location" }
)
vim.keymap.set(
	{'n', 'x'},
	'g,',
	function()
		local home = vim.fn.expand("~/Desktop/Code/")
		local prev = cd_with_strip(home)
		print("Switched to " .. home .. " from " .. prev)
	end,
	{ desc = "Changes global dir to all code files" }
)
--- Netrw
vim.keymap.set('n', '<space><space>', '<cmd>Explore<cr>', { desc = "Open on double space" })
--- Scissors (https://github.com/chrisgrieser/nvim-scissors?tab=readme-ov-file#example-for-the-vscode-style-snippet-format)
vim.keymap.set(
	"n",
	"<leader>se",
	function() require("scissors").editSnippet() end,
	{ desc = "Snippet: Edit" }
)

vim.keymap.set(
	{ "n", "x" },
	"<leader>sa",
	function() require("scissors").addNewSnippet() end,
	{ desc = "Snippet: Add" }
)
-- Telescope
vim.keymap.set(
	"i",
	"<C-n>",
	function() require('telescope.actions').cycle_history_next() end,
	{ desc = "Telescope: Cycle history next" }
)
vim.keymap.set(
	"i",
	"<C-p>",
	function() require('telescope.actions').cycle_history_prev() end,
	{ desc = "Telescope: Cycle history prev" }
)
vim.keymap.set(
	{"n", "x"},
	"<leader>f",
	function() require("telescope.builtin").find_files() end,
	{ desc = "Telescope: Open file finder" }
)


-- Packs (Plugins)
vim.pack.add({
	'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-treesitter/nvim-treesitter',
	'https://github.com/nvim-mini/mini.nvim',
	'https://github.com/saghen/blink.lib',
	'https://github.com/saghen/blink.cmp',
	'https://github.com/nvim-tree/nvim-web-devicons',
	'https://github.com/chrisgrieser/nvim-scissors',
	'https://github.com/nvim-telescope/telescope.nvim',
	'https://github.com/nvim-lua/plenary.nvim'
})

-- Color Schemes
vim.cmd.colorscheme('miniautumn')

-- LSPs
require('user.lsps.lua_ls')
require('user.lsps.bashls')

vim.lsp.enable('lua_ls')
vim.lsp.enable('bashls')

-- Plugins
--- Treesitter
require('nvim-treesitter').setup {
	install_dir = vim.fn.stdpath('data') .. '/site'
}
require('nvim-treesitter').install {
	'bash', 'c', 'cmake', 'cpp', 'dockerfile', 'gitignore',
	'jq', 'json', 'lua', 'markdown', 'nginx', 'python',
	'regex', 'typescript', 'yaml'
}
--- Blink
require('user.plugins.blink')

--- Nvim Scissors
require('scissors').setup({
	snippetDir = vim.fn.stdpath("config") .. "/lua/snippets"
})

--- Telescope
require('telescope').setup({})

--- Entry
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'cd to passed $PWD when vim starts.',
  group = vim.api.nvim_create_augroup('cd-to-pwd', { clear = true }),
  callback = function()
    local pwd = vim.fn.getcwd()
    vim.api.nvim_set_current_dir(pwd)
  end,
})
