vim.lsp.config('bashls', {
	cmd = { vim.fn.expand('~/AppData/Roaming/npm/bash-language-server.cmd'), 'start' },
	filetypes = { 'bash', 'sh' }
})
