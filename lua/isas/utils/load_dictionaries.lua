

local M = {}

local opts = require("isas.config").options
local isas_augroups = require("isas.utils.isas_augroups")
local isas_dicts = require("isas.completions.aa_dictionaries").arguments
local user_dicts = opts["dictionaries"]
-- local isas_dicts = {"en", "es", "pt"}

local function has_element(table, element, type)
	if (type == "value") then
		for index, value in pairs(table) do
			if value == element then return true end
		end
	elseif (type == "index") then
		for index, value in pairs(table) do
			if index == element then return true end
		end
	end

    return false
end

local function map_iabbrev(element, replacement)
	vim.cmd([[iabbrev ]]..element..[[ ]]..replacement)
end

function M.load()
	for u_dict in pairs(user_dicts) do
		if has_element(isas_dicts, u_dict, "value") then
			local inner_isas_dict = require("isas.dictionaries."..u_dict)
			for element in pairs(inner_isas_dict) do
				if has_element(user_dicts[u_dict], element, "index") then
					if not (user_dicts[u_dict][element] == "rm_isas") then
						inner_isas_dict[element] = user_dicts[u_dict][element]
					else
						table.remove(inner_isas_dict, element)
					end
				end
			end


			-- isas_augroups.set_augroups({
			-- 	_isas_group = {"ISAS_"..u_dict, '*', "lua for element in pairs(inner_isas_dict) do map_iabbrev(element, inner_isas_dict[element]) end"}
			-- })

			isas_augroups.set_augroups(
				'ISAS_'..u_dict,
				'*',
				'lua for element in pairs(inner_isas_dict) do map_iabbrev(element, inner_isas_dict[element]) end'
			)

			-- for element in pairs(inner_isas_dict) do
			-- 	map_iabbrev(element, inner_isas_dict[element])
			-- end
		else
			for element in pairs(user_dicts[u_dict]) do
				map_iabbrev(element, user_dicts[u_dict][element])
			end
		end
	end
end



return M



