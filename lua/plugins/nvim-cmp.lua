return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        window = {
          completion = {
            max_height = 10,
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-;>"] = cmp.mapping.select_next_item(), -- ;(qwerty) = n(bépo)
          ["<C-e>"] = cmp.mapping.select_prev_item(), -- e(qwerty) = p(bépo)
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-a>"] = cmp.mapping.abort(), -- a identique en qwerty/bépo
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        }),
      })
    end,
  },
}
