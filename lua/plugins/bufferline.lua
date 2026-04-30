return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { 
      "nvim-tree/nvim-web-devicons",
      "echasnovski/mini.bufremove",
    },
    opts = {
      options = {
        mode = "buffers", -- "tabs" si tu veux tabpages
        diagnostics = "nvim_lsp",
        separator_style = "slant", -- "thin" / "padded_slant" / etc.
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,

        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "left",
            separator = true, -- garde une séparation propre
          },
          {
            filetype = "dapui_scopes",
            text = "Debugger",
            text_align = "left",
            separator = true,
          },
        },
      },
    },

    config = function(_, opts)
      require("bufferline").setup(opts)
      require("mini.bufremove").setup()

      -- Bufferline: naviguer entre buffers
      vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer précédent" })
      vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer suivant" })

      -- Fermer le buffer courant
      --vim.keymap.set("n", "<leader>qh", "<cmd>bdelete<cr>", { desc = "Supprimer buffer" }) -- "qh"(qwerty) = "bc"(bépo)
      vim.keymap.set("n", "<leader>qh", function()
        require("mini.bufremove").delete(0, false)
      end, { desc = "Supprimer buffer" })

      -- Fermer les autres buffers
      -- "qr"(qwerty) = "bo"(bépo)
      vim.keymap.set("n", "<leader>qr", "<cmd>BufferLineCloseOthers<cr>", {
        desc = "Supprimer les autres buffers",
      })

      -- Fermer les buffers à droite
      -- "ql"(qwerty) = "br"(bépo)
      vim.keymap.set("n", "<leader>ql", "<cmd>BufferLineCloseRight<cr>", {
        desc = "Supprimer buffers à droite",
      })

      -- Fermer les buffers à gauche
      -- "qo"(qwerty) = "bl"(bépo)
      vim.keymap.set("n", "<leader>qo", "<cmd>BufferLineCloseLeft<cr>", {
        desc = "Supprimer buffers à gauche",
      })
    end,
  },
}
