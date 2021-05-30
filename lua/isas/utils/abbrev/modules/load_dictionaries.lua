

local M = {}

local opts = require("isas.config").options
local aa_ld = require("isas.completions.aa_loaded_dictionaries").loaded_dictionaries
local aa_ld0 = require("isas.completions.aa_loaded_dictionaries")
local isas_dicts = require("isas.dictionaries.langs_natural.langs_natural_list").arguments
local user_dicts = opts["natural_dictionaries"]
M.loaded_dicts = {}
vim.g.__isas_list_loaded_dicts = ""

local function append_glb_list()

end


local function remove_glb_list()

end

local function vimldict_to_luatbl(viml_dict)
	return luaeval('g:__isas_list_loaded_dicts')
end

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

local function remove_element_tbl(tbl, element)
	for key, value in pairs(tbl) do
		if (value == element) then
			tbl[key] = nil
		end
	end
end

local function parse_iabbrev_pr(tabl)

	local str_commands = ""

	for index, value in pairs(tabl) do
		local to_concat = "iabbrev "..index..[[ ]]..value
		str_commands = str_commands.."|"..to_concat
	end

	return str_commands

end

local function map_iabbrev(element, replacement)
	vim.cmd([[iabbrev ]]..element..[[ ]]..replacement)
end

local function unmap_iabbrev(element)
	vim.cmd([[iunabbrev ]]..element)
end

function M.load_dict(dict)
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
		table.insert(aa_ld, dict)
	elseif string.find(dict, "pr_") then

		local file_type = dict:gsub("pr_", "")
		local isas_langs_programming_list = require("isas.dictionaries.langs_programming.langs_programming_list").arguments
		local user_langs_programming_list = opts["programming_dictionaries"]

		if has_element(isas_langs_programming_list, dict, "value") then

			require("isas.utils.abbrev.modules.isas_augroups").set_augroups(
				"ISAS_"..dict,
				"BufWinEnter",
				"*."..file_type.." silent!",
				parse_iabbrev_pr(require("isas.dictionaries.langs_programming."..dict))
			)

		elseif has_element(user_langs_programming_list, dict, "value") then
			require("isas.utils.abbrev.modules.isas_augroups").set_augroups(
				"ISAS_"..dict,
				"BufWinEnter",
				"*."..file_type.." silent!",
				parse_iabbrev_pr(require("isas.dictionaries.langs_programming."..dict))
			)
		end

		table.insert(M.loaded_dicts, dict)
		table.insert(aa_ld, dict)
	else
		vim.cmd("echo 'Invalid argument, dictionary must have a nt_ or a pr_ prefix'")
	end

end
--
function M.unload_dict(dict)

	local isas_langs_natural_list = require("isas.dictionaries.langs_natural.langs_natural_list").arguments
	local user_langs_natural_list = opts["natural_dictionaries"]
	local isas_langs_programming_list = require("isas.dictionaries.langs_programming.langs_programming_list").arguments
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
			if has_element(user_langs_programming_list, dict, "value") then
				require("isas.utils.abbrev.modules.isas_augroups").unset_augroup("ISAS_"..dict)
			elseif has_element(isas_langs_programming_list, dict, "value") then
				require("isas.utils.abbrev.modules.isas_augroups").unset_augroup("ISAS_"..dict)
			end
		end

		vim.cmd("echo 'Dict = "..dict.."'")
		remove_element_tbl(M.loaded_dicts, dict)
		remove_element_tbl(aa_ld, dict)
		for key, value in pairs(M.loaded_dicts) do
			vim.cmd("echo 'Key = "..key.."; Value = "..value.."'")

		end

		-- vim.cmd("echo 'Runtime path = "..aa_ld0.runtime_path().."'")
		-- local to_cmd = "luafile "..aa_ld0.runtime_path()
		-- vim.cmd("echo 'ToCMd = "..to_cmd.."'")
		-- vim.cmd([[luafile ]]..aa_ld0.runtime_path()..[[]])
	else
		vim.cmd("echo 'Invalid argument, dictionary must have a nt_ or a pr_ prefix'")
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
					parse_iabbrev_pr(inner_isas_dict)
				)
				table.insert(M.loaded_dicts, u_dict)
				table.insert(aa_ld, u_dict)
			end

		else
			if (option == "source") then
				require("isas.utils.abbrev.modules.isas_augroups").set_augroups(
					"ISAS_"..u_dict,
					"BufEnter",
					"*"..file_type.." silent!",
					parse_iabbrev_pr(user_langs_programming_list[u_dict])
				)
				table.insert(M.loaded_dicts, u_dict)
				table.insert(aa_ld, u_dict)
			end
		end


	end

end

function M.load_natural_dictionaries_at_startup(option)
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

			if (option == "source") then
				for element in pairs(inner_isas_dict) do
					map_iabbrev(element, inner_isas_dict[element])
				end
				table.insert(M.loaded_dicts, u_dict)
				table.insert(aa_ld, u_dict)
			end
		else
			if (option == "source") then
				for element in pairs(user_dicts[u_dict]) do
					map_iabbrev(element, user_dicts[u_dict][element])
				end
				table.insert(M.loaded_dicts, u_dict)
				table.insert(aa_ld, u_dict)
			end
		end
	end
end



return M



