local case_transformers = require("change_case.case_transformers")

--- @param char string
local isLetter = function(char)
  return (char >= "a" and char <= "z") or (char >= "A" and char <= "Z")
end

--- @param char string
local isCapital = function(char)
  return (char >= "A" and char <= "Z")
end

--- @param prev string
--- @param peek string
local function isNewWordFromPeek(prev, peek)
  -- for snake-case and kebab-case
  if isLetter(prev) and not isLetter(peek) then
    return true
  end

  if not isCapital(prev) and isCapital(peek) then
    return true
  end

  return false
end

--- @param text string
--- @return string[]
local function split_into_words(text)
  local sub_words = {}
  local word_pointer = 1

  local index = 1
  while index <= #text do
    -- Extract the i-th character
    local curr_char = string.sub(text, index, index)
    local peek_char = string.sub(text, index + 1, index + 1)

    if isLetter(curr_char) then
      sub_words[word_pointer] = (sub_words[word_pointer] or "") .. curr_char

      if isNewWordFromPeek(curr_char, peek_char) then
        word_pointer = word_pointer + 1
      end
    end

    index = index + 1
  end

  return sub_words
end

---@param words string[]
---@param case string
local words_to_case = function(words, case)
  local case_transformer = case_transformers[case]

  local transformed_words = {}
  for index, word in ipairs(words) do
    table.insert(transformed_words, case_transformer.word_transformer(word, index))
  end

  return table.concat(transformed_words, case_transformer.separator)
end

local to_case = function(keyword, case)
  local words = split_into_words(keyword)
  return words_to_case(words, case)
end

local get_lsp_rename = function()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if not node or node:type() ~= "identifier" then
    return nil, ""
  end

  local clients = vim.lsp.buf_get_clients(0)
  for _, client in ipairs(clients) do
    if client.supports_method("textDocument/rename") then
      return vim.lsp.buf.rename, "LSP"
    end
  end
  return nil, ""
end

local get_treesitter_rename = function()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if not node or node:type() ~= "identifier" then
    return nil, ""
  end
  local bufnr = vim.api.nvim_get_current_buf()
  return function(new_name)
    local start_row, start_col, end_row, end_col = node:range()
    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { new_name })
  end,
    "treesitter"
end

local get_norm_rename = function()
  return function(new_text)
    vim.cmd(string.format("normal! ciw%s", new_text))
  end, "norma!"
end

return {

  split_into_words = split_into_words,
  words_to_case = words_to_case,
  to_case = to_case,

  --- @return fun(), string
  get_rename_fun = function()
    local lsp_rename, lsp_type = get_lsp_rename()
    if lsp_rename ~= nil then
      return lsp_rename, lsp_type
    end

    local treesitter_rename, treesitter_type = get_treesitter_rename()
    if treesitter_rename ~= nil then
      return treesitter_rename, treesitter_type
    end

    return get_norm_rename()
  end,

  -- get_visual_selection = function()
  --   -- Get the starting and ending positions of the visual selection
  --   local start_pos = vim.fn.getpos("'<")
  --   local end_pos = vim.fn.getpos("'>")
  --
  --   -- Extract the start and end positions (adjusted for 0-based indexing)
  --   local start_row = start_pos[2] - 1
  --   local start_col = start_pos[3] - 1
  --   local end_row = end_pos[2] - 1
  --   local end_col = end_pos[3]
  --
  --   local text = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})[1]
  --
  --   vim.notify(string.format("%d, %d, %d, %d", start_row, start_col, end_row, end_col))
  --   return start_row, start_col, end_row, end_col, text
  -- end,

  --- @param start_row integer
  --- @param start_col integer
  --- @param end_row integer
  --- @param end_col integer
  --- @param text string
  set_text = function(start_row, start_col, end_row, end_col, text)
    vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, { text })
  end,
}
