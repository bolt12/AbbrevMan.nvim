


local M = {}

M.arguments = {}
local loaded_dicts = require("isas.utils.abbrev.modules.load_dictionaries").loaded_dicts

function M.available_commands()
	for dict, dict_name in pairs(loaded_dicts) do
		M.arguments[dict_name] = dict_name
	end

	return vim.tbl_keys(M.arguments)
end



return M

