return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox")
      vim.cmd.colorscheme("carbonfox")
    end
  },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}
