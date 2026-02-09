-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "carbonfox" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

do
  local group = vim.api.nvim_create_augroup("LazyBepoKeys", { clear = true })

  local function apply(buf)
    -- petit délai pour passer après les keymaps posés par l'UI Lazy
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end

      local function map(lhs, rhs)
        pcall(vim.keymap.del, "n", lhs, { buffer = buf }) -- supprime l'existant (Lazy)
        vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, nowait = true })
      end

      map("N", "<cmd>Lazy help<cr>") -- Help (toggle)
      map("D", "<cmd>Lazy install<cr>")
      map("S", "<cmd>Lazy update<cr>")
      map("K", "<cmd>Lazy sync<cr>")
      map("C", "<cmd>Lazy clean<cr>")
      map("H", "<cmd>Lazy check<cr>")
      map("O", "<cmd>Lazy log<cr>")
      map("L", "<cmd>Lazy restore<cr>")
      map("P", "<cmd>Lazy profile<cr>")
      map("I", "<cmd>Lazy debug<cr>")
    end, 10) -- 10ms ; tu peux mettre 0/1/20 si besoin
  end

  vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "WinEnter" }, {
    group = group,
    pattern = "lazy",
    callback = function(ev)
      apply(ev.buf)
    end,
  })
end
