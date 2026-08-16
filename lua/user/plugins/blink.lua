-- Stolen from https://tduyng.com/blog/neovim-auto-completions/
local group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*",
	group = group,
	once = true,
	callback = function()
		require("blink.cmp").setup({
			keymap = { preset = "super-tab" },
			appearance = {
				nerd_font_variant = "mono",
				use_nvim_cmp_as_default = true,
			},
			menu = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 0
				}
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					snippets = {
						opts = {
							friendly_snippets = false,
							search_paths = { vim.fn.expand("~/AppData/Local/nvim/lua/snippets/") },
						}
					}
				}
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
			completion = {
				trigger = {
					show_on_backspace = false
				}
			},
		})
	end,
})

