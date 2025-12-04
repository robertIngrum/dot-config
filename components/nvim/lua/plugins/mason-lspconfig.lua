return {
	'mason-org/mason-lspconfig.nvim',
	dependencies = {
		'mason-org/mason.nvim',
		'neovim/nvim-lspconfig',
	},
	config = function()
		require('mason').setup()
		require('mason-lspconfig').setup({
			ensure_installed = { },
			handlers = {
				function(server_name)
					require('lspconfig')[server_name].setup({})
				end,
			},
		})
	end,
}

