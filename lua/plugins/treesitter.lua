return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",      -- optionnel si main est déjà par défaut
    lazy = false,         -- requis
    build = ":TSUpdate",  -- recommandé
    config = function()
      require("nvim-treesitter").setup({
        -- optionnel : install_dir = vim.fn.stdpath('data') .. '/site'
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  }
}
