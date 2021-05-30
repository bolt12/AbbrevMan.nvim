

local M = {}


function M.available_commands()

	M.arguments = {}

	for dict, dict_name in pairs(require("isas.utils.abbrev.modules.load_dictionaries").loaded_dicts) do
		M.arguments[dict_name] = dict_name
	end

	return vim.tbl_keys(M.arguments)
end



return M

