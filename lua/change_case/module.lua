local util = require("change_case.util")

---@class CustomModule
local M = {}

--- @param case Case
M.coherse_keyword = function(case)
  local keyword = vim.fn.expand("<cword>")
  local words = util.split_into_words(keyword)
  local updated_keyword = util.words_to_case(words, case)
  if keyword == updated_keyword then
    vim.notify("[change_case] No change required", vim.log.levels.INFO)
    return
  end

  local rename, rename_type = util.get_rename_fun()
  local ok, result = pcall(rename, updated_keyword)
  if not ok then
    vim.notify("[change_case] Failed to rename: " .. result, vim.log.levels.ERROR)
    return
  end

  vim.notify(
    string.format("[change_case] Converted '%s' to '%s' using '%s'", keyword, updated_keyword, rename_type),
    vim.log.levels.INFO
  )
end

--- @param case Case
-- M.coherse_visual = function(case)
--   local start_row, start_col, end_row, end_col, text = util.get_visual_selection()
--   local words = util.split_into_words(text)
--   local updated_text = util.words_to_case(words, case)
--   print(string.format("text = %s, updated_text = %s", text, updated_text))
--   if text == updated_text then
--     vim.notify("[change_case] No change required", vim.log.levels.INFO)
--     return
--   end
--
--   util.set_visual_selection(start_row, start_col, end_row, end_col, updated_text)
--
--   vim.notify(string.format("[change_case] Converted '%s' to '%s'", text, updated_text), vim.log.levels.INFO)
-- end

return M
