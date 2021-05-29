

local M = {}


local service = require("isas.utils.abbrev.service")

local function load_at_startup()
	service.load_at_startup()
end

function M.main(option)
	if (option == "load_at_startup") then
		load_at_startup()
	end
end



return M
