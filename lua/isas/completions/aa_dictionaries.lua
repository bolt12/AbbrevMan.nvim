

local M = {}

M.arguments = {}

local langs_natural_list = require("isas.dictionaries.langs_natural.langs_natural_list").arguments
local langs_programming_list = require("isas.dictionaries.langs_programming.langs_programming_list").arguments

function M.available_commands()

	for dict, dict_name in pairs(langs_natural_list) do
		M.arguments[dict_name] = dict_name
	end

	for dict, dict_name in pairs(langs_programming_list) do
		M.arguments[dict_name] = dict_name
	end

	return vim.tbl_keys(M.arguments)
end



return M

