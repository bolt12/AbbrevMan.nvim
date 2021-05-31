

local M = {}

local cmd = vim.cmd
local api = vim.api

local opts = require("isas.config").options
local permutation = require("isas.utils.abbrev.modules.permutation")
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

local function str_to_tbl(string)

	local tbl = {}

	for i = 1, #string do
		local char = string:sub(i,i)
		table.insert(tbl, char)
	end

	return tbl
end

local function tbl_to_str(tbl)

	local str = ""

	for key, value in pairs(tbl) do
		str = str..value
	end

	return str
end

local function map_iabbrev(element, replacement)
	cmd([[iabbrev ]]..element..[[ ]]..replacement)
end

local function map_iabbrev_permutation(element)
	local i = 0

	for p in permutation.perm(str_to_tbl(element)) do
		cmd([[iabbrev ]]..tbl_to_str(p)..[[ ]]..element)
		i = i + 1
	end
end

local function unmap_iabbrev(element, scope)

	scope = scope or "global"

	if (scope == "global") then
		cmd([[iunabbrev ]]..element)
	elseif (scope == "buffer") then
		cmd([[iunabbrev <buffer>]]..element)
	end
end

local function remove_element_tbl(tbl, element)
	for key, value in pairs(tbl) do
		if (value == element) then
			tbl[key] = nil
		end
	end
end

local function parse_iabbrev_pr(tabl, objective)

	local str_commands = ""

	if (objective == "global") then

		for index, value in pairs(tabl) do
			local to_concat = "iabbrev "..index..[[ ]]..value
			str_commands = str_commands.."|"..to_concat
		end
	elseif (objective == "buffer") then
		for index, value in pairs(tabl) do
			local to_concat = "iabbrev <buffer>"..index..[[ ]]..value
			str_commands = str_commands.."|"..to_concat
		end

	end

	return str_commands

end

function M.load_dict(dict)

	if not has_element(M.loaded_dicts, dict, "value") then

		if string.find(dict, "nt_") then

			local isas_langs_natural_list = require("isas.dictionaries.langs_natural.langs_natural_list").arguments
			local user_langs_natural_list = opts["natural_dictionaries"]

			if has_element(isas_langs_natural_list, dict, "value") then
				for element in pairs(require("isas.dictionaries.langs_natural."..dict)) do
					map_iabbrev(element, require("isas.dictionaries.langs_natural."..dict)[element])
				end
			elseif has_element(user_langs_natural_list, dict, "value") then
				for element in pairs(user_langs_natural_list[dict]) do
					map_iabbrev(element, user_langs_natural_list[dict][element])
				end
			end

			table.insert(M.loaded_dicts, dict)
		elseif string.find(dict, "pr_") then

			local file_type = dict:gsub("pr_", "")
			local isas_langs_programming_list = require("isas.dictionaries.langs_programming.langs_programming_list").arguments
			local user_langs_programming_list = opts["programming_dictionaries"]

			if has_element(isas_langs_programming_list, dict, "value") then

				require("isas.utils.abbrev.modules.isas_augroups").set_augroups(
					"ISAS_"..dict,
					"BufWinEnter",
					"*."..file_type.." silent!",
					parse_iabbrev_pr(require("isas.dictionaries.langs_programming."..dict), "buffer")
				)

				local buffer_filetype = api.nvim_eval([[expand('%:e')]])
				if (buffer_filetype == file_type) then
					cmd([[]]..parse_iabbrev_pr(require("isas.dictionaries.langs_programming."..dict), "buffer")..[[]])
				end

			elseif has_element(user_langs_programming_list, dict, "value") then
				require("isas.utils.abbrev.modules.isas_augroups").set_augroups(
					"ISAS_"..dict,
					"BufWinEnter",
					"*."..file_type.." silent!",
					parse_iabbrev_pr(require("isas.dictionaries.langs_programming."..dict), "buffer")
				)

				local buffer_filetype = api.nvim_eval([[expand('%:e')]])
				if (buffer_filetype == file_type) then
					cmd([[]]..parse_iabbrev_pr(user_langs_programming_list[dict], "buffer")..[[]])
				end

			end

			table.insert(M.loaded_dicts, dict)
		else
			cmd("echo 'Invalid argument, dictionary must have a nt_ or a pr_ prefix'")
		end
	else
		cmd("echo 'The dictionary you are trying to load has already been loaded or does not exist'")
	end

end

function M.unload_dict(dict)

	local isas_langs_natural_list = require("isas.dictionaries.langs_natural.langs_natural_list").arguments
	local isas_langs_programming_list = require("isas.dictionaries.langs_programming.langs_programming_list").arguments
	local user_langs_natural_list = opts["natural_dictionaries"]
	local user_langs_programming_list = opts["programming_dictionaries"]

	if has_element(M.loaded_dicts, dict, "value") then
		if string.find(dict, "nt_") then
			if has_element(isas_langs_natural_list, dict, "value") then
				for element in pairs(require("isas.dictionaries.langs_natural."..dict)) do
					unmap_iabbrev(element)
				end
			elseif has_element(user_langs_natural_list, dict, "value") then
				for element in pairs(require(user_langs_natural_list[dict])) do
					unmap_iabbrev(element)
				end
			end
		elseif string.find(dict, "pr_") then
			if has_element(isas_langs_programming_list, dict, "value") then
				require("isas.utils.abbrev.modules.isas_augroups").unset_augroup("ISAS_"..dict)
				for element in pairs(require("isas.dictionaries.langs_programming."..dict)) do
					unmap_iabbrev(element, "buffer")
				end
			elseif has_element(user_langs_programming_list, dict, "value") then
				require("isas.utils.abbrev.modules.isas_augroups").unset_augroup("ISAS_"..dict)
				for element in pairs(require(user_langs_programming_list[dict])) do
					unmap_iabbrev(element, "buffer")
				end
			end
		end

		remove_element_tbl(M.loaded_dicts, dict)
	else
		cmd("echo 'The dictionary you are trying to unload has not been loaded yet or does not exist")
	end

end

function M.load_programming_dictionaries_at_startup(option)

	local isas_langs_programming_list = require("isas.dictionaries.langs_programming.langs_programming_list").arguments
	local user_langs_programming_list = opts["programming_dictionaries"]

	for u_dict in pairs(user_langs_programming_list) do

		local file_type = u_dict:gsub("pr_", "")

		if has_element(isas_langs_programming_list, u_dict, "value") then

			local inner_isas_dict = require("isas.dictionaries.langs_programming."..u_dict)

			for element in pairs(inner_isas_dict) do
				if has_element(user_langs_programming_list[u_dict], element, "index") then
					if not (user_langs_programming_list[u_dict][element] == "rm_isas") then
						inner_isas_dict[element] = user_langs_programming_list[u_dict][element]
					else
						inner_isas_dict[element] = nil -- remove element
					end
				end
			end

			if (option == "source") then
				require("isas.utils.abbrev.modules.isas_augroups").set_augroups(
					"ISAS_"..u_dict,
					"BufWinEnter",
					"*."..file_type.." silent!",
					parse_iabbrev_pr(inner_isas_dict, "buffer")
				)

				table.insert(M.loaded_dicts, u_dict)
			end

		else
			if (option == "source") then
				require("isas.utils.abbrev.modules.isas_augroups").set_augroups(
					"ISAS_"..u_dict,
					"BufEnter",
					"*"..file_type.." silent!",
					parse_iabbrev_pr(user_langs_programming_list[u_dict], "buffer")
				)

				table.insert(M.loaded_dicts, u_dict)
			end
		end
	end
end

function M.load_natural_dictionaries_at_startup(option)
	for u_dict in pairs(user_dicts) do
		if has_element(isas_dicts, u_dict, "value") then

			local inner_isas_dict = require("isas.dictionaries.langs_natural."..u_dict)
			local perm_status = opts["natural_dictionaries"][u_dict]["permutation_enabled"]
			local nrml_status = opts["natural_dictionaries"][u_dict]["normal_enabled"]

			vim.cmd("echo 'Dict = "..tostring(inner_isas_dict.normal).."'")



-- 			for element in pairs(inner_isas_dict.normal) do
-- 				if has_element(user_dicts[u_dict]["normal"], element, "index") then
-- 					if not (user_dicts[u_dict]["normal"][element] == "rm_isas") then
-- 						inner_isas_dict.normal[element] = user_dicts[u_dict]["normal"][element]
-- 					else
-- 						inner_isas_dict.normal[element] = nil -- remove element
-- 					end
-- 				end
-- 			end
--
-- 			for element in pairs(inner_isas_dict.permutate) do
-- 				if has_element(user_dicts[u_dict]["permutate"], element, "index") then
-- 					if not (user_dicts[u_dict]["permutate"][element] == "rm_isas") then
-- 						inner_isas_dict.permutate[element] = user_dicts[u_dict]["permutate"][element]
-- 					else
-- 						inner_isas_dict.permutate[element] = nil -- remove element
-- 					end
-- 				end
-- 			end




			if (option == "source") then
				if (nrml_status ~= nil and nrml_status == true) then
					for element in pairs(inner_isas_dict.normal) do
						map_iabbrev(element, inner_isas_dict.normal[element])
					end
					table.insert(M.loaded_dicts, u_dict)
				elseif (perm_status ~= nil and perm_status == true) then
					for element in pairs(inner_isas_dict.permutate) do
						map_iabbrev_permutation(element)
					end
					table.insert(M.loaded_dicts, u_dict)
				end
			end
		else
			vim.cmd("Nohing happened")
			-- if (option == "source") then
			-- 	for element in pairs(user_dicts[u_dict]) do
			-- 		map_iabbrev(element, user_dicts[u_dict][element])
			-- 	end
			-- 	table.insert(M.loaded_dicts, u_dict)
			-- end
		end
	end
end



return M

