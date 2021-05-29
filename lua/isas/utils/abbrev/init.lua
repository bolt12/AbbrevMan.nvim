

local M = {}


local service = require("isas.utils.abbrev.service")

local function load_at_startup()
	service.load_at_startup()
end

local function load_dict(dict)
	-- vim.cmd("echo '1 NEW DICT = "..dict.."'")
	service.load_dict(dict)
end

local function unload_dict(dict)
	-- vim.cmd("echo '1 NEW DICT = "..dict.."'")
	service.unload_dict(dict)
end

function M.main(option, sub_option)

	sub_option = sub_option or "NONE"

	if (option == "load_at_startup") then
		load_at_startup()
	elseif (option == "load_dict") then
		load_dict(sub_option)
	elseif (option == "unload_dict") then
		unload_dict(sub_option)
	end
end



return M

