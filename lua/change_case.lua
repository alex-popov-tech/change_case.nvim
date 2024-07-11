-- main module file
local module = require("change_case.module")

---@class Config
local config = {}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@param args Config?
-- M.setup = function(args) end

M.coherse_keyword = module.coherse_keyword
-- M.coherse_visual = module.coherse_visual

return M
