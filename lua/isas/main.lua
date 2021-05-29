

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
				--
				require("isas.utils.load_dictionaries").load()
			end
		end
	end
end



return M

