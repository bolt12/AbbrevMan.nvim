

local config = {}

config.options = {
	load_at_startup = true,
	integrations = {
		integration_nvim_autopairs = true
	},
	dictionaries = {
		["en"] = {}
				-- ["Iam"] = "I am",
				-- ["Im"] = "I'm",
				-- ["TEh"] = "The"
		-- }
	}
}



function config.set_options(opts)

    opts = opts or {}

    for opt, _ in pairs(opts) do
		if (config.options[opt] ~= nil) then		-- not nil
			if (type(opts[opt]) == "table" and opt ~= "dictionaries") then	-- if table
				for inner_opt, _ in pairs(opts[opt]) do
					if (config.options[opt][inner_opt] ~= nil) then		-- not nil
						config.options[opt][inner_opt] = opts[opt][inner_opt]
					end
				end
			else
				config.options[opt] = opts[opt]
			end
		end
	end

end



return config
