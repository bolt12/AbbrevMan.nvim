


local M = {}

M.arguments = {}
-- local loaded_dicts = require("isas.utils.abbrev.modules.load_dictionaries").loaded_dicts
vim.g.__isas_val = "yooooo"

M.loaded_dictionaries = {}

function M.available_commands()

	-- for dict, dict_name in pairs(require("isas.utils.abbrev.modules.load_dictionaries").loaded_dicts) do
	for dict, dict_name in pairs(M.loaded_dictionaries) do
		M.arguments[dict_name] = dict_name
	end

	M.arguments[vim.g.__isas_val] = vim.g.__isas_val

	return vim.tbl_keys(M.arguments)
end

function M.runtime_path()
	-- return vim.api.nvim_eval("expand('<sfile>:p')")
	return vim.api.nvim_eval("get(g:, '__isas_main_path', 0)").."/lua/isas/completions/aa_loaded_dictionaries.lua"
end


return M

