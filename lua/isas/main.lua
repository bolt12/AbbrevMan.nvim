

local M = {}

local opts = require("isas.config").options


function M.main(option, command_option)

	option = option or 0
	command_option = command_option or 'load'

	if (option == 0) then
		if (command_option == 'load') then
			require("isas.init").setup_start_command()
		else
			if (opts["load_at_startup"] == true) then
				require("isas.utils.abbrev.init").main("load_at_startup")
			end
		end
	elseif (option == 1) then
		vim.cmd("echo '0 NEW DICT = "..command_option.."'")
		require("isas.utils.abbrev.init").main("load_dict", command_option)
	end
end



return M

