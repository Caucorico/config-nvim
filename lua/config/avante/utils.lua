local M = {}

function M.read_file(path)
  local expanded = vim.fn.expand(path)
  if vim.fn.filereadable(expanded) == 0 then
    return ("Prompt file not found: %s"):format(expanded)
  end
  return table.concat(vim.fn.readfile(expanded), "\n")
end

function M.git_root()
  local cwd = vim.fn.getcwd()
  local out = vim.system({ "git", "-C", cwd, "rev-parse", "--show-toplevel" }, { text = true }):wait()
  if out.code ~= 0 then
    return nil
  end
  return vim.trim(out.stdout)
end

function M.joinpath(...)
  return table.concat({ ... }, "/")
end

return M
