

local M = {}

function M.load_at_startup()
	require("isas.utils.abbrev.modules.load_dictionaries").load_at_startup()
end

function M.load_dict()
end

function M.unload_dict()
end


return M

