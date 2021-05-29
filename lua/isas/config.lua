

local config = {}

config.options = {
	load_at_startup = true,
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
			if not (opt == "enabled_dictionaries") then
				config.options[opt] = opts[opt]
			end
		end
	end

end




return config
