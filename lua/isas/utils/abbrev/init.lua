

local M = {}


local service = require("isas.utils.abbrev.service")

local function load_at_startup()
	service.load_at_startup()
end

local function load_dict()
	service.load_dict()
end

function M.main(option, sun_option)

	sun_option = sun_option or "NONE"

	if (option == "load_at_startup") then
		load_at_startup()
	elseif (option == "load_dict") then
		load_dict()
	end
end



return M
