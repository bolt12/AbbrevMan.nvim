

local M = {}


-- function M.load_global_tables()
-- 	_G_loaded_dicts = {}
-- end

function M.setup_start_command()
	vim.cmd("command! ISASStart lua require'isas.utils.load_dictionaries'.load()")
end

function M.setup(custome_opts)
	require("isas.config").set_options(custome_opts)
	-- M.load_global_tables()
end


return M

