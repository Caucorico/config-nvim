return {
  {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 900,
    opts = {
      timeout = 2000,
      stages = "fade_in_slide_out",
      render = "default",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)

      -- Remplace vim.notify par nvim-notify
      vim.notify = notify

      local macro_notification = nil
      local current_macro_register = nil

      local group = vim.api.nvim_create_augroup("BigMacroRecordingNotify", {
        clear = true,
      })

      vim.api.nvim_create_autocmd("RecordingEnter", {
        group = group,
        callback = function()
          -- On schedule pour être sûr que reg_recording() soit déjà disponible
          vim.schedule(function()
            local reg = vim.fn.reg_recording()
            current_macro_register = reg

            macro_notification = notify(
              table.concat({
                "",
                "██████╗ ███████╗ ██████╗",
                "██╔══██╗██╔════╝██╔════╝",
                "██████╔╝█████╗  ██║     ",
                "██╔══██╗██╔══╝  ██║     ",
                "██║  ██║███████╗╚██████╗",
                "╚═╝  ╚═╝╚══════╝ ╚═════╝",
                "",
                "      MACRO @" .. reg,
                "",
              }, "\n"),
              vim.log.levels.WARN,
              {
                title = "Recording macro",
                timeout = false, -- reste affiché tant que tu enregistres
              }
            )
          end)
        end,
      })

      vim.api.nvim_create_autocmd("RecordingLeave", {
        group = group,
        callback = function()
          local reg = current_macro_register or "?"

          notify("■ Stopped recording @" .. reg, vim.log.levels.INFO, {
            title = "Macro saved",
            timeout = 1200,
            replace = macro_notification,
          })

          macro_notification = nil
          current_macro_register = nil
        end,
      })
    end,
  },
}
