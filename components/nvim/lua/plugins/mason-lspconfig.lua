return {
	'mason-org/mason-lspconfig.nvim',
	dependencies = {
		'mason-org/mason.nvim',
		'neovim/nvim-lspconfig',
	},
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem = {
			documentationFormat = { "markdown", "plaintext" },
			snippetSupport = true,
			preselectSupport = true,
			insertReplaceSupport = true,
			labelDetailsSupport = true,
			deprecatedSupport = true,
			commitCharactersSupport = true,
			tagSupport = { valueSet = { 1 } },
			resolveSupport = {
				properties = {
					"documentation",
					"detail",
					"additionalTextEdits",
				},
			},
		}

		require('mason').setup()
		require('mason-lspconfig').setup({
			ensure_installed = { },
			handlers = {
				function(server_name)
					require('lspconfig')[server_name].setup({
						capabilities = capabilities,
					})
				end,
			},
		})
	end,
}

