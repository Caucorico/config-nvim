return {
  {
    "rcarriga/nvim-notify",
    lazy = false, -- chargé au démarrage (recommandé si tu veux que vim.notify soit remplacé partout)
    priority = 900, -- avant pas mal d'autres plugins UI
    opts = {
      -- opts optionnels, tu peux laisser vide si tu veux
      -- timeout = 2000,
      -- stages = "fade_in_slide_out",
      -- render = "default",
      -- max_height = function() return math.floor(vim.o.lines * 0.75) end,
      -- max_width  = function() return math.floor(vim.o.columns * 0.75) end,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)

      -- Remplace vim.notify par nvim-notify
      vim.notify = notify
    end,
  },
}
