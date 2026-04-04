local M = {}

function M.opts()
  return {
    provider = "copilot",
    mode = "agentic",
    instructions_file = "avante.md",
    behaviour = {
      auto_approve_tool_permissions = false,
      auto_apply_diff_after_generation = false,
      confirmation_ui_style = "popup",
    },
    web_search_engine = {
      provider = "searxng",
      proxy = nil,
    },
    shortcuts = require("config.avante.shortcuts"),
    custom_tools = require("config.avante.tools"),
  }
end

function M.setup(_, opts)
  require("avante").setup(opts)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "AvanteSelectedCode",
    callback = function(ctx)
      vim.keymap.set("n", "D", function()
        local ok, avante = pcall(require, "avante")
        if not ok then
          return
        end

        local sidebar = avante.get()
        if not sidebar then
          return
        end

        sidebar.code.selection = nil

        if sidebar.containers and sidebar.containers.selected_code then
          sidebar.containers.selected_code:unmount()
          sidebar.containers.selected_code = nil
        end
      end, { buffer = ctx.buf, desc = "Avante: retirer le selected code" })
    end,
  })
end

return M
