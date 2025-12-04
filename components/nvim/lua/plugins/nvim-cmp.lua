return {
	"hrsh7th/nvim-cmp",
	version = false,
	event = "InsertEnter",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			dependencies = "rafamadriz/friendly-snippets",
			opts = { history = true, updateevents = "TextChanged,TextChangedI" },
			config = function(_, opts)
				require("luasnip").config.set_config(opts)
				require "config.luasnip"
			end,
		},

		-- autopairing of (){}[] etc
		{
			"windwp/nvim-autopairs",
			opts = {
				fast_wrap = {},
				disable_filetype = { "TelescopePrompt", "vim" },
			},
			config = function(_, opts)
				require("nvim-autopairs").setup(opts)

				-- setup cmp for autopairs
				local cmp_autopairs = require "nvim-autopairs.completion.cmp"
				require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end,
		},

		-- cmp sources plugins
		{
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"https://codeberg.org/FelipeLema/cmp-async-path.git"
		}
	},
	opts = function()
		-- Register nvim-cmp lsp capabilities
		vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
		local cmp = require("cmp")
		local defaults = require("cmp.config.default")()
		local auto_select = true

		local cmp_util = require("util/cmp")

		return {
			auto_brackets = {}, -- configure any filetype to auto add brackets
      completion = {
        completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
      },
      preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
      mapping = cmp.mapping.preset.insert({
				["<C-j>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, { 'i', 's' }),
				["<C-k>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { 'i', 's' }),
				["<Esc>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.abort()
					else
						fallback()
					end
				end),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp_util.confirm({ select = auto_select }),
      }),
      sources = cmp.config.sources({
        { name = "lazydev" },
        { name = "nvim_lsp" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
      formatting = {
        format = function(entry, item)
          local icons = {
						Array         = " ",
						Boolean       = "󰨙 ",
						Class         = " ",
						Codeium       = "󰘦 ",
						Color         = " ",
						Control       = " ",
						Collapsed     = " ",
						Constant      = "󰏿 ",
						Constructor   = " ",
						Copilot       = " ",
						Enum          = " ",
						EnumMember    = " ",
						Event         = " ",
						Field         = " ",
						File          = " ",
						Folder        = " ",
						Function      = "󰊕 ",
						Interface     = " ",
						Key           = " ",
						Keyword       = " ",
						Method        = "󰊕 ",
						Module        = " ",
						Namespace     = "󰦮 ",
						Null          = " ",
						Number        = "󰎠 ",
						Object        = " ",
						Operator      = " ",
						Package       = " ",
						Property      = " ",
						Reference     = " ",
						Snippet       = "󱄽 ",
						String        = " ",
						Struct        = "󰆼 ",
						Supermaven    = " ",
						TabNine       = "󰏚 ",
						Text          = " ",
						TypeParameter = " ",
						Unit          = " ",
						Value         = " ",
						Variable      = "󰀫 ",
					}

          if icons[item.kind] then
            item.kind = icons[item.kind] .. item.kind
          end

          local widths = {
            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
          }

          for key, width in pairs(widths) do
            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
              item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
            end
          end

          return item
        end,
      },
      experimental = {
        -- only show ghost text when we show ai completions
        ghost_text = vim.g.ai_cmp and {
          hl_group = "CmpGhostText",
        } or false,
      },
      sorting = defaults.sorting,
    }
  end,
  -- main = "lazyvim.util.cmp",
}

