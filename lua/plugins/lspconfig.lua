return {
  -- LSP base
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Mason
  {
    "mason-org/mason.nvim",
    opts = {},
  },

  -- Mason <-> LSP (v2+)
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "antosha417/nvim-lsp-file-operations",
    },
    opts = {
      ensure_installed = {
        "basedpyright",
        "ruff",
        "phpactor",
      },
      automatic_enable = true, -- v2+: c’est le mécanisme “magique” officiel
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Capabilities (cmp + lsp-file-operations)
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      local ok_lspfo, lspfo = pcall(require, "lsp-file-operations")
      if ok_lspfo then
        capabilities = vim.tbl_deep_extend("force", capabilities, lspfo.default_capabilities())
      end

      -- Config des serveurs (API native Neovim 0.11+)
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

      vim.lsp.config("ruff", {
        capabilities = capabilities,
      })

      vim.lsp.config("phpactor", {
        capabilities = capabilities,
        filetypes = { "php" },
      })

      -- Keymaps LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts2 = { buffer = ev.buf, silent = true }
          vim.keymap.set("n", "<leader>,i", vim.lsp.buf.definition, opts2)
          vim.keymap.set("n", "<leader>,l", vim.lsp.buf.references, opts2)
          vim.keymap.set("n", "<leader>B", vim.lsp.buf.hover, opts2)
          vim.keymap.set("n", "<leader>l;", vim.lsp.buf.rename, opts2)
          vim.keymap.set("n", "<leader>ha", vim.lsp.buf.code_action, opts2)
          vim.keymap.set("n", "<leader>f", function()
            vim.diagnostic.open_float(nil, { focus = false })
          end, { buffer = ev.buf, silent = true, desc = "Diagnostic (popup)" })
        end,
      })

      require("config.phpactor_commands").setup()
    end,
  },
}
