

local M = {}


function M.setup(custome_opts)
	require("isas.config").set_options(custome_opts)
	-- M.load_global_tables()
end


return M

