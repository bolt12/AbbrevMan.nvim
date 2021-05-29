


local M = {}

M.arguments = {}
local loaded_dicts = require("lua.isas.utils.abbrev.modules.load_dictionaries").loaded_dicts

function M.available_commands()
	for dict, _ in pairs(loaded_dicts) do
		M.arguments[dict] = dict
	end

	return vim.tbl_keys(M.arguments)
end



return M

