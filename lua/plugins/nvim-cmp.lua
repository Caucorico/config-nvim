return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-;>"] = cmp.mapping.select_next_item(), -- ;(qwerty) = n(bépo)
          ["<C-e>"] = cmp.mapping.select_prev_item(), --e(qwerty) = p(bépo)
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(), -- f(qwerty) = e(bépo)
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "buffer" },
        }),
      })
    end,
  },
}
