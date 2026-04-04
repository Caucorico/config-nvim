local skills = require("config.avante.skills")
local project = require("config.avante.project")

local function run_openspec(args)
  local cmd = project.openspec_cmd()
  vim.list_extend(cmd, args)

  local out = vim.system(cmd, { text = true }):wait()

  if out.code ~= 0 then
    return out.stderr ~= "" and out.stderr or ("Commande échouée (code %d)"):format(out.code)
  end

  return out.stdout ~= "" and out.stdout or out.stderr
end

return {
  {
    name = "openspec_list_changes",
    description = "Lister les changes OpenSpec du projet",
    param = {
      type = "table",
      fields = {},
    },
    returns = {
      { name = "result", type = "string", description = "Sortie de openspec list" },
      { name = "error", type = "string", description = "Erreur éventuelle", optional = true },
    },
    func = function(_, _, _)
      return run_openspec({ "list" })
    end,
  },
  {
    name = "openspec_show",
    description = "Afficher un change ou une spec OpenSpec",
    param = {
      type = "table",
      fields = {
        {
          name = "item",
          description = "Nom du change ou de la spec à afficher",
          type = "string",
        },
      },
    },
    returns = {
      { name = "result", type = "string", description = "Sortie de openspec show" },
      { name = "error", type = "string", description = "Erreur éventuelle", optional = true },
    },
    func = function(params, _, _)
      local item = params.item
      if not item or item == "" then
        return "Erreur: paramètre 'item' requis."
      end
      return run_openspec({ "show", item })
    end,
  },
  {
    name = "openspec_status",
    description = "Afficher le statut d'un change OpenSpec",
    param = {
      type = "table",
      fields = {
        {
          name = "change",
          description = "Nom du change OpenSpec",
          type = "string",
        },
      },
    },
    returns = {
      { name = "result", type = "string", description = "Sortie de openspec status" },
      { name = "error", type = "string", description = "Erreur éventuelle", optional = true },
    },
    func = function(params, _, _)
      local change = params.change
      if not change or change == "" then
        return "Erreur: paramètre 'change' requis."
      end
      return run_openspec({ "status", change })
    end,
  },
  {
    name = "openspec_instructions",
    description = "Récupérer les instructions OpenSpec pour un artefact ou une phase",
    param = {
      type = "table",
      fields = {
        {
          name = "artifact",
          description = "Nom de l'artefact ou de la phase (ex: proposal, design, tasks, apply)",
          type = "string",
        },
      },
    },
    returns = {
      { name = "result", type = "string", description = "Sortie de openspec instructions" },
      { name = "error", type = "string", description = "Erreur éventuelle", optional = true },
    },
    func = function(params, _, _)
      local artifact = params.artifact
      if not artifact or artifact == "" then
        return "Erreur: paramètre 'artifact' requis."
      end
      return run_openspec({ "instructions", artifact })
    end,
  },
  {
    name = "copilot_list_skills",
    description = "Lister les Copilot skills disponibles dans .github/skills du dépôt courant",
    param = {
      type = "table",
      fields = {},
    },
    returns = {
      { name = "result", type = "string", description = "Liste des skills détectés" },
      { name = "error", type = "string", description = "Erreur éventuelle", optional = true },
    },
    func = function(_, _, _)
      local discovered, err = skills.discover_skills()
      if err then
        return err
      end
      return skills.format_skill_list(discovered)
    end,
  },
  {
    name = "copilot_load_skill",
    description = "Charger le contenu du fichier SKILL.md d'un Copilot skill du dépôt courant",
    param = {
      type = "table",
      fields = {
        {
          name = "skill",
          description = "Identifiant du skill à charger. Utiliser de préférence la valeur 'id' retournée par copilot_list_skills.",
          type = "string",
        },
      },
    },
    returns = {
      { name = "result", type = "string", description = "Contenu du SKILL.md et métadonnées associées" },
      { name = "error", type = "string", description = "Erreur éventuelle", optional = true },
    },
    func = function(params, _, _)
      local result, err = skills.load_skill(params.skill)
      return result or err
    end,
  },
}
