return {
	-- Command palette + symbols + references pickers
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
		keys = {
			{ "<leader>p",  "<cmd>Telescope commands<cr>",   desc = "Command palette" },
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Grep" },
		},
	},

	-- Peek definition / references
	{
		"dnlhc/glance.nvim",
		cmd = "Glance",
		opts = { border = { enable = true } },
	},

	-- Rename with live preview
	{
		"smjonas/inc-rename.nvim",
		opts = {},
	},

	-- Doxygen comment generator
	{
		"danymat/neogen",
		cmd = "Neogen",
		opts = {
			snippet_engine = "nvim",
			languages = {
				cpp = { template = { annotation_convention = "doxygen" } },
				c = { template = { annotation_convention = "doxygen" } }
			},
		},
	},

	-- Chat / explain / review (needs a GitHub Copilot subscription)
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = { "github/copilot.vim", "nvim-lua/plenary.nvim" },
		cmd = { "CopilotChat", "CopilotChatExplain", "CopilotChatReview" },
		opts = {},
	},
}
