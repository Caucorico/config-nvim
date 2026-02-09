return {
  {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },

    config = function()
      local builtin = require('telescope.builtin')

      -- / = f in qwerty to bépo
      -- , = g in qwerty to bépo
      -- q = b in qwerty to bépo
      -- . = h in qwerty to bépo
      -- l = r in qwerty to bépo
      -- ] = w in qwerty to bépo
      vim.keymap.set('n', '<leader>//', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>/,', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>/q', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>/.', builtin.help_tags, { desc = 'Telescope help tags' })
      vim.keymap.set('n', '<leader>/l', builtin.oldfiles, { desc = 'Telescope recent files' })
      vim.keymap.set('n', '<leader>/]', builtin.grep_string, { desc = 'Telescope grep word' })
    end
  },
}
