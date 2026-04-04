return {
  -- ouvrir / fermer / naviguer
  { "<leader>ar", "<cmd>AvanteToggle<cr>", desc = "Avante ouvrir/fermer" }, --ao(bépo) = ar(qwerty)
  -- { "<leader>a/", "<cmd>AvanteFocus<cr>", desc = "Avante focus" }, --af(bépo) = a/(qwerty) -> disabled, same as AvanteAsk
  { "<leader>al", "<cmd>AvanteRefresh<cr>", desc = "Avante rafraîchir" }, --ar(bépo) = al(qwerty)

  -- interactions principales
  { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Avante interroger" }, --ai(bépo) = ad(qwerty)
  { "<leader>ac", "<cmd>AvanteChat<cr>", desc = "Avante chat" }, --ac(bépo) = ah(qwerty)
  { "<leader>a;", "<cmd>AvanteChatNew<cr>", desc = "Avante nouveau chat" }, -- an(bépo) = a;(qwerty)
  { "<leader>af", "<cmd>AvanteEdit<cr>", mode = "v", desc = "Avante éditer la sélection" }, --ae(bépo) = af(qwerty)

  -- historique / contrôle
  { "<leader>a.", "<cmd>AvanteHistory<cr>", desc = "Avante historique" }, -- ah(bépo) = a.(qwerty)
  { "<leader>ak", "<cmd>AvanteStop<cr>", desc = "Avante stopper" }, -- as(bépo) = ak(qwerty)
  { "<leader>ao", "<cmd>AvanteClear<cr>", desc = "Avante nettoyer le chat" }, --al(bépo) = ao(qwerty)

  -- provider / modèle / repomap
  { "<leader>ae", "<cmd>AvanteSwitchProvider<cr>", desc = "Avante provider" }, --ap(bépo) = ae(qwerty)
  { "<leader>a'", "<cmd>AvanteModels<cr>", desc = "Avante modèles" }, -- am(bépo) = a'(qwerty)
  { "<leader>a,", "<cmd>AvanteShowRepoMap<cr>", desc = "Avante repo map" }, --ag(bépo) = a,(qwerty)

  -- fichiers
  { "<leader>aq", "<cmd>AvanteAddCurrentBuffer<cr>", desc = "Avante ajouter buffer" }, --ab(bépo) = aq(qwerty)
}
