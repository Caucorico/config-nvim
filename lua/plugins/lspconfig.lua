return {
  -- LSP base
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Mason: installe les outils (LSP, linters, formatters)
  {
    "mason-org/mason.nvim",
    opts = {},
  },

  -- Mason <-> LSP (v2)
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "basedpyright", -- évite npm
        "ruff",
        "phpactor",
      },
      automatic_enable = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Capabilities (optionnel : s'active si tu as nvim-cmp)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- BasedPyright
      vim.lsp.config("basedpyright", {
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
            },
          },
        },
      })

      -- Ruff (lint + quickfix)
      vim.lsp.config("ruff", {
        capabilities = capabilities,
      })

      vim.lsp.config("phpactor", {
        capabilities = capabilities,
        filetypes = { "php" },
      })

      -- (optionnel) Keymaps LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts2 = { buffer = ev.buf, silent = true }
          vim.keymap.set("n", "<leader>,i", vim.lsp.buf.definition, opts2) -- ",i"(qwerty) = "gd"(bépo)
          vim.keymap.set("n", "<leader>,l", vim.lsp.buf.references, opts2) -- ",l"(qwerty) = "gr"(bépo)
          vim.keymap.set("n", "<leader>B", vim.lsp.buf.hover, opts2) -- "B"(qwerty) = "K"(bépo)
          vim.keymap.set("n", "<leader>l;", vim.lsp.buf.rename, opts2) -- "l;"(qwerty) = "rn"(bépo) 
          vim.keymap.set("n", "<leader>ha", vim.lsp.buf.code_action, opts2) -- "ha"(qwerty) = "ca"(bépo)
          vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, { buffer = ev.buf, silent = true, desc = "Diagnostic (popup)" }) -- "f"(qwerty) = "e"(bépo)
        end,
      })
    end,
  },
}
