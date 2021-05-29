
local M = {}

local opts = require("isas.config").options

M.arguments = {}

local function has_element(table, element, type)
	if (type == "value") then
		for index, value in pairs(table) do
			if value == element then return true end
		end
	elseif (type == "index") then
		for index, value in pairs(table) do
			if index == element then return true end
		end
	end

    return false
end


function M.available_commands()

	local isas_dicts = require("isas.completions.aa_dictionaries").arguments
	local user_dicts = opts["natural_dictionaries"]

	for dict in pairs(isas_dicts) do
		M.arguments[dict] = dict
	end

	for dict in pairs(user_dicts) do
		if not has_element(M.arguments, dict, "value") then
			M.arguments[dict] = dict
		end
	end

	return vim.tbl_keys(M.arguments)
end



return M

