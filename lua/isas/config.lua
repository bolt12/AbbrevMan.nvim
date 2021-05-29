

local config = {}

config.options = {
	load_natural_dictionaries_at_startup = true,
	load_programming_dictionaries_at_startup = true,
	integrations = {
		integration_nvim_autopairs = true
	},
	natural_dictionaries = {
		["nt_en"] = {}
	},
	programming_dictionaries = {
		["pr_python"] = {}
	}
}



function config.set_options(opts)

    opts = opts or {}

    for opt, _ in pairs(opts) do
		vim.cmd("echo 'Opt = "..opt.."'")
		if (config.options[opt] ~= nil) then		-- not nil
			vim.cmd("echo 'Got hereeeeeeeeeeeeeeeeeeeee'")
			if (type(opts[opt]) == "table") then
			-- if (type(opts[opt]) == "table" and opt ~= "natural_dictionaries") then

				-- vim.cmd("echo 'Was a table'")
				-- 	for inner_opt, _ in pairs(opts[opt]) do
				-- 		if (config.options[opt][inner_opt] ~= nil) then		-- not nil
				-- 			config.options[opt][inner_opt] = opts[opt][inner_opt]
				-- 		end
				-- 	end

				if (opt ~= "natural_dictionaries") then
					vim.cmd("echo 'Was not natural or programming'")
					for inner_opt, _ in pairs(opts[opt]) do
						if (config.options[opt][inner_opt] ~= nil) then		-- not nil
							config.options[opt][inner_opt] = opts[opt][inner_opt]
						end
					end
				end
			else
				config.options[opt] = opts[opt]
			end
		end
	end

end



return config

