

local M = {}

local opts = require("isas.config").options
-- local isas_dicts = require("isas.completions.aa_dictionaries").arguments
local isas_dicts = require("isas.dictionaries.langs_natural.langs_natural_list").arguments
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

-- function M.mutable_load_at_startup(user_dictionary, isas_dictionary, lang_type)
--
-- 	for u_dict in pairs(user_dictionary) do
-- 		if has_element(isas_dictionary, u_dict, "value") then
-- 			local inner_isas_dictionary = require("isas.dictionaries."..lang_type.."."..u_dict)
-- 			for element in pairs(inner_isas_dictionary) do
-- 				if has_element(user_dictionary[u_dict], element, "index") then
-- 					if not (user_dictionary[u_dict][element] == "rm_isas") then
-- 						inner_isas_dictionary[element] = user_dictionary[u_dict][element]
-- 					else
-- 						inner_isas_dictionary[element] = nil -- remove element
-- 					end
-- 				end
-- 			end
--
-- 			for element in pairs(inner_isas_dict) do
-- 				map_iabbrev(element, inner_isas_dict[element])
-- 			end
-- 			table.insert(M.loaded_dicts, u_dict)
-- 		else
--
-- 		end
-- 	end
-- end

-- function M.load_natural_dictionaries_at_startup()
--
-- end

local function parse_iabbrev_pr(tabl)

	local str_commands = ""

	for index, value in pairs(tabl) do
		local to_concat = "iabbrev "..index..[[ ]]..value
		str_commands = str_commands.."|"..to_concat
	end

	return str_commands

end

function M.load_programming_dictionaries_at_startup()

	local isas_langs_programming_list = require("isas.dictionaries.langs_programming.langs_programming_list").arguments
	local user_langs_programming_list = opts["programming_dictionaries"]


	for key in pairs(isas_langs_programming_list) do
		vim.cmd("echo 'Key = "..key.."'")
	end


	for u_dict in pairs(user_langs_programming_list) do
		vim.cmd("echo 'U dict = "..u_dict.."'")
	end

	for u_dict in pairs(user_langs_programming_list) do
		if has_element(isas_langs_programming_list, u_dict, "value") then
			vim.cmd("echo 'Got here'")
--
-- 			local inner_isas_dict = require("isas.dictionaries.langs_programming."..u_dict)
--
-- 			for element in pairs(inner_isas_dict) do
-- 				if has_element(user_langs_programming_list[u_dict], element, "index") then
-- 					if not (user_langs_programming_list[u_dict][element] == "rm_isas") then
-- 						inner_isas_dict[element] = user_langs_programming_list[u_dict][element]
-- 					else
-- 						inner_isas_dict[element] = nil -- remove element
-- 					end
-- 				end
-- 			end
-- --
-- 			local file_type = u_dict:gsub("pr_", "")
-- 			-- vim.cmd("echo '"..file_type.."'")
-- 			-- vim.cmd("echo '"..parse_iabbrev_pr(inner_isas_dict).."'")
-- -- --
-- 			require("isas.utils.abbrev.modules.isas_augroups").set_augroups(
-- 				"ISAS_"..u_dict,
-- 				"BufEnter",
-- 				"*."..file_type,
-- 				parse_iabbrev_pr(inner_isas_dict)
-- 			)
-- --
			table.insert(M.loaded_dicts, u_dict)
		else
			vim.cmd("echo 'Got here 1'")
-- 			local file_type = u_dict:gsub("pr_", "")
--
-- 			require("isas.utils.abbrev.modules.isas_augroups").set_augroups(
-- 				"ISAS_"..u_dict,
-- 				"BufEnter",
-- 				"*"..file_type,
-- 				parse_iabbrev_pr(user_langs_programming_list[u_dict])
-- 			)
			table.insert(M.loaded_dicts, u_dict)
		end

	end

end

function M.load_natural_dictionaries_at_startup()

	-- for key in pairs(isas_dicts) do
	-- 	vim.cmd("echo 'Key = "..key.."'")
	-- end

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

			vim.cmd("echo 'Got here'")
			for element in pairs(inner_isas_dict) do
				map_iabbrev(element, inner_isas_dict[element])
			end
			table.insert(M.loaded_dicts, u_dict)
		else
			vim.cmd("echo 'Got here 1'")
			for element in pairs(user_dicts[u_dict]) do
				map_iabbrev(element, user_dicts[u_dict][element])
			end
			table.insert(M.loaded_dicts, u_dict)
		end
	end
end



return M



