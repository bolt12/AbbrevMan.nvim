

local M = {}

local opts = require("isas.config").options
local user_dicts = opts["dictionaries"]
local isas_dicts = {"en", "es", "pt"}

local function has_value(table, val)
    for index, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

local function map_iabbrev(element, replacement)
	vim.cmd([[iabbrev ]]..element..[[ ]]..replacement)
end

function M.load()

	for u_dict in pairs(user_dicts) do
		if has_value(isas_dicts, u_dict) then

			local inner_isas_dict = require("isas.dictionaries."..u_dict)

			for element in pairs(inner_isas_dict) do
				if has_value(user_dicts[u_dict], element) then
					inner_isas_dict[element] = user_dicts[u_dict][element]
					-- if not (user_dicts[u_dict][element] == "rm_isas") then
					-- 	inner_isas_dict[element] = user_dicts[u_dict][element]
					-- else
					-- 	table.
					-- end
				end
			end

			for element in pairs(inner_isas_dict) do
				map_iabbrev(element, inner_isas_dict[element])
			end

		end
	end

end



return M



