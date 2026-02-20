return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        php = { "php_cs_fixer" }, -- ou "phpcbf" ou "pint"
      },
      formatters = {
        php_cs_fixer = {
          command = "php",
          args = { "./vendor/bin/php-cs-fixer", "fix", "$FILENAME", "--quiet" },
          stdin = false,
        },
      },
      format_on_save = {
        timeout_ms = 2000,
        lsp_format = "fallback",
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      -- format manuel
      vim.keymap.set({ "n", "v" }, "<leader>/", function() -- /(qwerty) = f (bépo)
        require("conform").format({ timeout_ms = 2000, lsp_format = "fallback" })
      end, { desc = "Format (Conform)" })
    end,
  }
}
