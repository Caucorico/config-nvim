local utils = require("config.avante.utils")
local project = require("config.avante.project")

local M = {}

function M.parse_skill_metadata(skill_md_path)
  local expanded = vim.fn.expand(skill_md_path)
  if vim.fn.filereadable(expanded) == 0 then
    return nil
  end

  local lines = vim.fn.readfile(expanded)
  local name = nil
  local description = nil

  if lines[1] == "---" then
    for i = 2, #lines do
      local line = lines[i]
      if line == "---" then
        break
      end
      local k, v = line:match("^([%w_-]+):%s*(.*)$")
      if k == "name" then
        name = v:gsub('^["' .. "'" .. ']', ""):gsub('["' .. "'" .. ']$', "")
      elseif k == "description" then
        description = v:gsub('^["' .. "'" .. ']', ""):gsub('["' .. "'" .. ']$', "")
      end
    end
  end

  local dir_name = vim.fn.fnamemodify(vim.fn.fnamemodify(expanded, ":h"), ":t")

  return {
    id = dir_name,
    name = (name and name ~= "") and name or dir_name,
    description = description or "",
    path = expanded,
  }
end

function M.discover_skills()
  local root = project.root()
  if not root then
    return {}, "Impossible de déterminer la racine git du projet."
  end

  local skills_root = project.skills_dir()
  if not skills_root then
    return {}, "Impossible de résoudre le dossier des skills."
  end

  if vim.fn.isdirectory(skills_root) == 0 then
    return {}, ("Dossier de skills introuvable: %s"):format(skills_root)
  end

  local found = vim.fn.globpath(skills_root, "*/SKILL.md", false, true)
  local skills = {}

  for _, skill_md in ipairs(found) do
    local meta = M.parse_skill_metadata(skill_md)
    if meta then
      table.insert(skills, meta)
    end
  end

  table.sort(skills, function(a, b)
    return a.name:lower() < b.name:lower()
  end)

  return skills, nil
end

function M.format_skill_list(skills)
  if #skills == 0 then
    return "Aucun skill trouvé."
  end

  local out = { "Skills disponibles :" }
  for _, skill in ipairs(skills) do
    table.insert(out, ("- id: %s"):format(skill.id))
    table.insert(out, ("  name: %s"):format(skill.name))
    table.insert(out, ("  description: %s"):format(skill.description ~= "" and skill.description or "(aucune description)"))
    table.insert(out, ("  path: %s"):format(skill.path))
  end

  return table.concat(out, "\n")
end

function M.load_skill(requested)
  if not requested or requested == "" then
    return nil, "Erreur: paramètre 'skill' requis."
  end

  local skills, err = M.discover_skills()
  if err then
    return nil, err
  end

  local requested_lower = requested:lower()
  local match = nil

  for _, skill in ipairs(skills) do
    if skill.id:lower() == requested_lower or skill.name:lower() == requested_lower then
      match = skill
      break
    end
  end

  if not match then
    return nil, ("Erreur: skill introuvable: %s"):format(requested)
  end

  local content = utils.read_file(match.path)
  return table.concat({
    ("Skill id: %s"):format(match.id),
    ("Skill name: %s"):format(match.name),
    ("Skill description: %s"):format(match.description ~= "" and match.description or "(aucune description)"),
    ("Skill path: %s"):format(match.path),
    "",
    "--- BEGIN SKILL.md ---",
    content,
    "--- END SKILL.md ---",
  }, "\n"), nil
end

return M
