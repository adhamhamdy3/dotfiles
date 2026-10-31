return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    opts = {
      -- use nvim-lspconfig names, not Mason package names
      ensure_installed = {
        "lua_ls",
        "clangd",
        "pyright",
        "ts_ls",
        "bashls",
        "jsonls",
        "cmake",
      },
      automatic_enable = true, -- auto vim.lsp.enable() for installed servers
    },
    config = function(_, opts)
      -- global defaults for every server (completion capabilities)
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- per-server overrides
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
        },
      })

      require("mason-lspconfig").setup(opts)
    end,
  },

  -- Formatters / linters / debuggers (not LSP servers)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "stylua",        -- lua formatter
        "clang-format",  -- c/c++ formatter
        "black",         -- python formatter
        "prettier",      -- js/ts/json/md formatter
        "shfmt",         -- shell formatter
        "codelldb",      -- c/c++ debugger
      },
      run_on_start = true,
    },
  },

  -- Format on save using the tools Mason installed
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        sh = { "shfmt" },
      },
      format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
    },
  },

  -- Completion
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = { keymap = { preset = "default" } },
  },
}
