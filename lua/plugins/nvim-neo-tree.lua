return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    keys = {
      -- fo qwerty = el bépo
      { "<leader>fo", "<cmd>Neotree filesystem reveal left<cr>", desc = "Neo-tree toggle left" },
      -- fl qwerty = er bépo
      { "<leader>fl", "<cmd>Neotree filesystem reveal right<cr>", desc = "Neo-tree toggle right" },
    },
    config = function()
      require("neo-tree").setup({
        window = {
          mappings = {
            ["<C-r>"] = "none",
          },
        }, -- <- VIRGULE

        filesystem = {
          window = {
            mappings = {
              ["N"] = "show_help",
              ["<space>"] = "open",
            },
          },
        },

        open_files_do_not_replace_types = {
          "terminal",
          "qf",
          "Trouble",

          -- dap-ui
          "dapui_scopes",
          "dapui_breakpoints",
          "dapui_stacks",
          "dapui_watches",
          "dapui_console",

          -- dap repl (selon ton setup)
          "dap-repl",
        },
      })
    end,
  },
}
