local M = {}

local function ucfirst(s)
  return (s:gsub("^%l", string.upper))
end

local function to_pascal_case(name)
  -- reference_client -> ReferenceClient
  name = name:gsub("_([%l%d])", function(c)
    return c:upper()
  end)

  -- dateDepot -> DateDepot
  return ucfirst(name)
end

local function parse_php_property(line)
  -- Enlève les commentaires simples de fin de ligne
  line = line:gsub("//.*$", "")

  local rest = line:match("^%s*public%s+(.+)$")
  if not rest then
    rest = line:match("^%s*protected%s+(.+)$")
  end
  if not rest then
    rest = line:match("^%s*private%s+(.+)$")
  end
  if not rest then
    return nil
  end

  -- Ignore les méthodes
  if rest:match("^function%s+") or rest:match("^static%s+function%s+") then
    return nil
  end

  local before_name, name = rest:match("^(.-)%$([%a_][%w_]*)")
  if not name then
    return nil
  end

  local type_parts = {}
  for token in before_name:gmatch("%S+") do
    if token ~= "readonly" and token ~= "static" then
      table.insert(type_parts, token)
    end
  end

  local typ = table.concat(type_parts, " ")

  return {
    name = name,
    type = typ,
  }
end

local function find_current_class_bounds(bufnr)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local class_start = nil

  for i = cursor_line, 1, -1 do
    if lines[i]:match("^%s*[%a%s]*class%s+[%a_]") then
      class_start = i
      break
    end
  end

  if not class_start then
    return nil, nil, lines
  end

  local depth = 0
  local started = false

  for i = class_start, #lines do
    local line = lines[i]
    local opens = select(2, line:gsub("{", ""))
    local closes = select(2, line:gsub("}", ""))

    if opens > 0 then
      started = true
    end

    if started then
      depth = depth + opens - closes
    end

    if started and depth == 0 then
      return class_start, i, lines
    end
  end

  return class_start, nil, lines
end

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

  vim.api.nvim_create_user_command("PhpGenerateAllAccessors", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local class_start, class_end, lines = find_current_class_bounds(bufnr)

    if not class_start or not class_end then
      vim.notify("Impossible de trouver la classe courante", vim.log.levels.WARN)
      return
    end

    local class_text = table.concat(
      vim.list_slice(lines, class_start, class_end),
      "\n"
    )

    local props = {}
    local seen = {}

    for i = class_start, class_end do
      local prop = parse_php_property(lines[i])

      if prop and not seen[prop.name] then
        seen[prop.name] = true
        table.insert(props, prop)
      end
    end

    if #props == 0 then
      vim.notify("Aucune propriété trouvée dans la classe", vim.log.levels.INFO)
      return
    end

    local generated = {}

    for _, prop in ipairs(props) do
      local method = "get" .. to_pascal_case(prop.name)

      if not class_text:find("function%s+" .. method .. "%s*%(") then
        local return_type = ""
        if prop.type and prop.type ~= "" then
          return_type = ": " .. prop.type
        end

        table.insert(generated, "")
        table.insert(generated, "    public function " .. method .. "()" .. return_type)
        table.insert(generated, "    {")
        table.insert(generated, "        return $this->" .. prop.name .. ";")
        table.insert(generated, "    }")
      end
    end

    if #generated == 0 then
      vim.notify("Tous les getters semblent déjà exister", vim.log.levels.INFO)
      return
    end

    -- Insertion juste avant l'accolade finale de la classe.
    vim.api.nvim_buf_set_lines(bufnr, class_end - 1, class_end - 1, false, generated)

    vim.notify(
      ("Getters générés pour %d propriété(s)"):format(#generated / 5),
      vim.log.levels.INFO
    )
  end, {
    desc = "Generate getters for all PHP properties in current class",
  })

  vim.keymap.set("n", "<leader>h<lt>", "<cmd>PhpGenerateAllAccessors<CR>", {
    silent = true,
    desc = "Generate all PHP getters",
  })
end

return M
