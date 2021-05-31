

local M = {}


function M.available_commands()
	-- this table must be reset always because nothing is removing the elemtns that were removed from the below module
	-- simple solution
	M.arguments = {}

	for dict, dict_name in pairs(require("abbrev-man.utils.abbrev.modules.load_dictionaries").loaded_dicts) do
		M.arguments[dict_name] = dict_name
	end
	return vim.tbl_keys(M.arguments)
end



return M

