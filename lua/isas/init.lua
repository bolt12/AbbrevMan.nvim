

local M = {}


function M.setup_start_command()
	vim.cmd("command! ISASStart lua require'isas.utils.load_dictionaries'.load()")
end

function M.setup(custome_opts)
	require("isas.config").set_options(custome_opts)
end


return M

