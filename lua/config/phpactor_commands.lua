local M = {}

function M.setup()
  local PHP_ACTOR = vim.fn.expand("~/.local/share/nvim/mason/packages/phpactor/phpactor.phar")
  local function sh(s) return vim.fn.shellescape(s) end

  vim.api.nvim_create_user_command("PhpactorFixFile", function()
    local file = vim.fn.expand("%:p")
    local cmd = "php " .. sh(PHP_ACTOR)
      .. " class:transform " .. sh(file)
      .. " --transform=fix_namespace_class_name"
    vim.cmd("!" .. cmd)
  end, { desc = "Phpactor: fix namespace/class name for current file" })

  vim.api.nvim_create_user_command("PhpactorFixDir", function(opts)
    local dir = (opts.args and opts.args ~= "") and opts.args or vim.fn.expand("%:p:h")
    local cmd = "bash -lc " .. sh(
      'DIR=' .. sh(dir)
        .. '; find "$DIR" -type f -name "*.php" -print0'
        .. ' | xargs -0 -n1 php ' .. sh(PHP_ACTOR)
        .. ' class:transform --transform=fix_namespace_class_name'
    )
    vim.cmd("!" .. cmd)
  end, {
    desc = "Phpactor: fix namespace/class name recursively in a directory",
    nargs = "?",
    complete = "dir",
  })

  vim.api.nvim_create_user_command("PhpactorFixProject", function()
    local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if not root or root == "" then root = vim.fn.getcwd() end
    vim.cmd("PhpactorFixDir " .. sh(root))
  end, { desc = "Phpactor: fix namespace/class name for whole project" })
end

return M
