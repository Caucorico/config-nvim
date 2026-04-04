local utils = require("config.avante.utils")

local M = {}

local defaults = {
  copilot_root = ".github",
  openspec_cmd = { "openspec" },
}

local function load_project_file(path)
  local expanded = vim.fn.expand(path)
  if vim.fn.filereadable(expanded) == 0 then
    return {}
  end

  local chunk, err = loadfile(expanded)
  if not chunk then
    vim.notify(
      ("[avante] impossible de charger %s: %s"):format(expanded, err),
      vim.log.levels.WARN
    )
    return {}
  end

  local ok, result = pcall(chunk)
  if not ok then
    vim.notify(
      ("[avante] erreur dans %s: %s"):format(expanded, result),
      vim.log.levels.WARN
    )
    return {}
  end

  if type(result) ~= "table" then
    vim.notify(
      ("[avante] %s doit retourner une table"):format(expanded),
      vim.log.levels.WARN
    )
    return {}
  end

  return result
end

function M.root()
  return utils.git_root()
end

function M.get()
  local root = M.root()
  if not root then
    return vim.deepcopy(defaults)
  end

  local cfg_path = utils.joinpath(root, ".avante.lua")
  local local_cfg = load_project_file(cfg_path)

  return vim.tbl_deep_extend("force", vim.deepcopy(defaults), local_cfg)
end

function M.resolve_from_root(path_value)
  local root = M.root()
  if not root then
    return nil
  end

  if not path_value or path_value == "" then
    return root
  end

  local expanded = vim.fn.expand(path_value)

  if vim.startswith(expanded, "/") then
    return expanded
  end

  return utils.joinpath(root, path_value)
end

function M.copilot_root()
  local cfg = M.get()
  return M.resolve_from_root(cfg.copilot_root or ".github")
end

function M.skills_dir()
  local copilot_root = M.copilot_root()
  if not copilot_root then
    return nil
  end
  return utils.joinpath(copilot_root, "skills")
end

function M.prompts_dir()
  local copilot_root = M.copilot_root()
  if not copilot_root then
    return nil
  end
  return utils.joinpath(copilot_root, "prompts")
end

function M.openspec_cmd()
  local cfg = M.get()
  local cmd = cfg.openspec_cmd

  if type(cmd) == "string" and cmd ~= "" then
    return { cmd }
  end

  if type(cmd) == "table" and #cmd > 0 then
    return vim.deepcopy(cmd)
  end

  return { "openspec" }
end

return M
