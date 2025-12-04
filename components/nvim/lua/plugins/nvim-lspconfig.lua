return {
	'neovim/nvim-lspconfig',
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local M = {}
		local map = vim.keymap.set

		M.on_attach = function(_, bufnr)
			local function opts(desc)
				return { buffer = bufnr, desc = "LSP" .. desc }
			end

			map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
			map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
			map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
		end

		M.capabilities = vim.lsp.protocol.make_client_capabilities()

		M.capabilities.textDocument.completion.completionItem = {
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

		M.defaults = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					M.on_attach(_, args.buf)
				end,
			})

			vim.lsp.config("*", { capabilities = M.capabilities })
		end

		M.defaults()
	end
}

