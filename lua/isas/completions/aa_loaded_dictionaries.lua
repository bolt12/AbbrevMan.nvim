


local M = {}

-- local loaded_dicts = require("isas.utils.abbrev.modules.load_dictionaries").loaded_dicts
M.loaded_dictionaries = {}

function M.available_commands()


	M.arguments = {}

	for dict, dict_name in pairs(require("isas.utils.abbrev.modules.load_dictionaries").loaded_dicts) do
	-- for dict, dict_name in pairs(M.loaded_dictionaries) do
		M.arguments[dict_name] = dict_name
	end

	return vim.tbl_keys(M.arguments)
end


return M

