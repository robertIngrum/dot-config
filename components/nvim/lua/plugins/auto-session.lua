return {
	"rmagatti/auto-session",
	lazy = false,
	keys = {
		{ "<leader>se", "<cmd>AutoSession search<CR>", desc = "[S]ession s[e]arch" },
	},
	--enables autocomplete for opts
	--@module "auto-session"
	--@type AutoSession.Config
	opts = {
		suppressed_dirs = {
			"~/",
			"~/Projects",
			"~/Downloads",
			"/",
		},
		session_lens = {
			picker = "telescope"
		}
	}
}

