

local M = {}

local opts = require("isas.config").options
local isas_dicts = require("isas.completions.aa_dictionaries").arguments
local user_dicts = opts["natural_dictionaries"]
M.loaded_dicts = {}

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

local function unmap_iabbrev(element)
	vim.cmd([[iunabbrev ]]..element)
end

local function find_index(tabl, element)
	for index, value in pairs(tabl) do
		if (value == element) then
			return index
		end
	end
end

function M.load_dict(dict)
	if has_element(isas_dicts, dict, "value") then
		for element in pairs(require("isas.dictionaries.langs_natural."..dict)) do
			map_iabbrev(element, require("isas.dictionaries.langs_natural."..dict)[element])
		end
	elseif has_element(user_dicts, dict, "value") then
		for element in pairs(user_dicts[dict]) do
			map_iabbrev(element, user_dicts[dict][element])
		end
	end

	table.insert(M.loaded_dicts, dict)

end
--
function M.unload_dict(dict)
	if has_element(M.loaded_dicts, dict, "value") then
		if has_element(isas_dicts, dict, "value") then
			for element in pairs(require("isas.dictionaries.langs_natural."..dict)) do
				unmap_iabbrev(element)
			end
		elseif has_element(user_dicts, dict, "value") then
			for element in pairs(user_dicts[dict]) do
				unmap_iabbrev(element)
			end
		end
	end
end

function M.load_at_startup()
	for u_dict in pairs(user_dicts) do
		if has_element(isas_dicts, u_dict, "value") then
			local inner_isas_dict = require("isas.dictionaries.langs_natural."..u_dict)
			for element in pairs(inner_isas_dict) do
				if has_element(user_dicts[u_dict], element, "index") then
					if not (user_dicts[u_dict][element] == "rm_isas") then
						inner_isas_dict[element] = user_dicts[u_dict][element]
					else
						inner_isas_dict[element] = nil -- remove element
					end
				end
			end

			for element in pairs(inner_isas_dict) do
				map_iabbrev(element, inner_isas_dict[element])
			end
			table.insert(M.loaded_dicts, u_dict)
		else
			for element in pairs(user_dicts[u_dict]) do
				map_iabbrev(element, user_dicts[u_dict][element])
			end
			table.insert(M.loaded_dicts, u_dict)
		end
	end
end



return M



