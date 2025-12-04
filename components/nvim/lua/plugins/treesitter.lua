return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	lazy = "false",
	build = ":TSUpdate",
	configs = function()
		require('nvim-treesitter.configs').setup({
			ensure_installed = { "c++", "lua" },
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
			},
		})
	end
}
