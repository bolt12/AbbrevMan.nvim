

local M = {}

local opts = require("isas.config").options


function M.main(option, command_option)

	option = option or 0
	command_option = command_option or 'load'

	if (option == 0) then
		if (command_option == 'load') then
			require("isas.init").setup_start_command()
		elseif (command_option == "load_natural_dictionaries_at_startup") then
				require("isas.utils.abbrev.init").main("load_natural_dictionaries_at_startup")
		else
--
--
-- 			if (opts["load_natural_dictionaries_at_startup"] == true) then
-- 				require("isas.utils.abbrev.init").main("load_natural_dictionaries_at_startup")
-- 			end
		end
	elseif (option == 1) then
		-- vim.cmd("echo '0 NEW DICT = "..command_option.."'")
		require("isas.utils.abbrev.init").main("load_dict", command_option)
	elseif (option == 2) then
		-- vim.cmd("echo '0 NEW DICT = "..command_option.."'")
		require("isas.utils.abbrev.init").main("unload_dict", command_option)
	end
end



return M

