return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- Keymaps
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step Out" })
      vim.keymap.set("n", "<Leader>iq", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" }) -- iq(qwerty) = db(bépo)
      vim.keymap.set("n", "<Leader>iQ", function() -- iQ(qwerty) = dB(bépo)
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "DAP: Conditional Breakpoint" })
      vim.keymap.set("n", "<Leader>il", dap.repl.open, { desc = "DAP: REPL" }) -- il(qwerty) = dr(bépo)
      vim.keymap.set("n", "<Leader>im", dap.terminate, { desc = "DAP: Terminate" }) -- im(qwerty) = dq(bépo)
      vim.keymap.set("n", "<Leader>ih", dap.run_to_cursor, { desc = "DAP: Run to Cursor" }) -- ih(qwerty) = dc(bépo)

      -- Auto open/close dap-ui (si installé)
      local ok_dapui, dapui = pcall(require, "dapui")
      if ok_dapui then
        vim.keymap.set("n", "<Leader>is", dapui.toggle, { desc = "DAP: Toggle UI" }) -- is(qwerty) = du(bépo)

        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end
      end

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug (9003)",
          port = 9003,
          -- utile si tu débugges dans Docker / VM :
          pathMappings = { ["/var/www/html"] = "${workspaceFolder}" },
        },
        {
          type = "php",
          request = "launch",
          name = "Debug current script (CLI)",
          program = "${file}",
          cwd = "${workspaceFolder}",
          port = 9003,
        },
      }
    end
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason-org/mason.nvim", "nvim-dap" },
    opts = {
      automatic_installation = true,
      ensure_installed = { "php" }, -- selon versions: "php" / "php-debug-adapter"
      handlers = {},
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.35 },
              { id = "breakpoints", size = 0.20 },
              { id = "stacks", size = 0.20 },
              { id = "watches", size = 0.25 },
            },
            position = "right",
            size = 50,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 12,
          },
        },
      })
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "nvim-dap" },
    config = true,
  },
}
