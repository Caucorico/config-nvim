local utils = require("config.avante.utils")
local project = require("config.avante.project")

local M = {}

local function prompt_name_from_path(path)
  local filename = vim.fn.fnamemodify(path, ":t")
  local base = filename:gsub("%.prompt%.md$", "")
  return base:gsub("%-", "_")
end

local function prompt_description_from_name(name)
  return ("Prompt chargé depuis %s"):format(name)
end

function M.discover_prompt_files()
  local prompts_dir = project.prompts_dir()
  if not prompts_dir then
    return {}, "Impossible de résoudre le dossier des prompts."
  end

  if vim.fn.isdirectory(prompts_dir) == 0 then
    return {}, ("Dossier de prompts introuvable: %s"):format(prompts_dir)
  end

  local files = vim.fn.globpath(prompts_dir, "*.prompt.md", false, true)
  table.sort(files)
  return files, nil
end

function M.build_shortcuts()
  local files, err = M.discover_prompt_files()
  if err then
    vim.notify(("[avante] %s"):format(err), vim.log.levels.WARN)
    return {}
  end

  local shortcuts = {}

  for _, path in ipairs(files) do
    local name = prompt_name_from_path(path)

    table.insert(shortcuts, {
      name = name,
      description = prompt_description_from_name(name),
      prompt = utils.read_file(path),
    })
  end

  return shortcuts
end

return M.build_shortcuts()
