return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    config = function()
	require('nvim-treesitter.configs').setup({
	    highlight = { enable = true },
	    indent = { enable = true },
	    auto_install = false,
	    ensure_installed = {
		'astro', 'cmake', 'cpp', 'css', 'fish', 'gitignore', 'go',
		'graphql', 'http', 'java', 'php', 'rust', 'scss', 'sql', 'svelte',
	    },
	})
    end,
}
