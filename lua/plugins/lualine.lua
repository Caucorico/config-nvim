return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    opts = function()
      local my_theme = {
        normal = {
          a = { fg = "#ff0000", bg = "#78a9ff", gui = "bold" },
          b = { fg = "#0000ff", bg = "#2a3441" },
          c = { fg = "#00ff00", bg = "#1b222d" },
        },
        insert = {
          a = { fg = "#ff0000", bg = "#98c379", gui = "bold" },
          b = { fg = "#c6d0f5", bg = "#2a3441" },
          c = { fg = "#c6d0f5", bg = "#1b222d" },
        },
        visual = {
          a = { fg = "#0b0f14", bg = "#c678dd", gui = "bold" },
          b = { fg = "#c6d0f5", bg = "#2a3441" },
          c = { fg = "#c6d0f5", bg = "#1b222d" },
        },
        replace = {
          a = { fg = "#0b0f14", bg = "#e06c75", gui = "bold" },
          b = { fg = "#c6d0f5", bg = "#2a3441" },
          c = { fg = "#c6d0f5", bg = "#1b222d" },
        },
        command = {
          a = { fg = "#00ff00", bg = "#e5c07b", gui = "bold" },
          b = { fg = "#c6d0f5", bg = "#2a3441" },
          c = { fg = "#c6d0f5", bg = "#1b222d" },
        },
        inactive = {
          a = { fg = "#8b949e", bg = "#1b222d", gui = "bold" },
          b = { fg = "#8b949e", bg = "#1b222d" },
          c = { fg = "#8b949e", bg = "#1b222d" },
        },
      }

      return {
        options = {
          icons_enabled = true,
          theme = 'carbonfox',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
              'WinEnter',
              'BufEnter',
              'BufWritePost',
              'SessionLoadPost',
              'FileChangedShellPost',
              'VimResized',
              'Filetype',
              'CursorMoved',
              'CursorMovedI',
              'ModeChanged',
            },
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  },
}
