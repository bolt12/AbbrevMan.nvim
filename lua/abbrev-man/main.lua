

local M = {}

local opts = require("abbrev-man.config").options
local abbrev = require("abbrev-man.utils.abbrev.init")


function M.main(option, command_option)

	option = option or 0
	command_option = command_option or 'load'

	if (option == 0) then
		if (command_option == "load_natural_dictionaries_at_startup") then
			if (opts["load_natural_dictionaries_at_startup"] == true) then
				abbrev.main("load_natural_dictionaries_at_startup", "source")
			else
				abbrev.main("load_natural_dictionaries_at_startup", "unsource")
			end
		elseif (command_option == "load_programming_dictionaries_at_startup") then
			if (opts["load_programming_dictionaries_at_startup"] == true) then
				abbrev.main("load_programming_dictionaries_at_startup", "source")
			else
				abbrev.main("load_programming_dictionaries_at_startup", "unsource")
			end
		else
			-- nothing
		end
	elseif (option == 1) then
		abbrev.main("load_dict", command_option)
	elseif (option == 2) then
		abbrev.main("unload_dict", command_option)
	end
end



return M

