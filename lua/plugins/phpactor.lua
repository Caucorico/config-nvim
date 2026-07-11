return {
  {
    "gbprod/phpactor.nvim",
    ft = "php",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      install = {
        -- Important : même si c'est sous "install", ce chemin est utilisé
        -- par les commandes RPC comme :PhpActor generate_accessor
        bin = vim.fn.stdpath("data") .. "/mason/packages/phpactor/phpactor.phar",
        php_bin = "php",
      },
      lspconfig = {
        enabled = false, -- important : tu gardes ta config LSP actuelle
      },
    },
  },
}
