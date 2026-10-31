return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
	end,
	config = function()
		require("nvim-tree").setup({
			hijack_directories = { enable = true, auto_open = true }, -- the default, shown for clarity
			view = { width = 35 },
			renderer = { group_empty = true },
			filters = { dotfiles = false },
			git = { enable = true },
			diagnostics = { enable = true },
			update_focused_file = { enable = true },
		})
		vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
		vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeFindFile<cr>", { desc = "Reveal current file" })
	end,
}
