

local M = {}

local cmd = vim.cmd
local api = vim.api

local opts = require("abbrev-man.config").options
local am_dicts = require("abbrev-man.dictionaries.langs_natural.langs_natural_list").arguments
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
	-- vim.cmd("echo 'Mapping: "..element.."; To: "..replacement.."'")
	cmd([[iabbrev ]]..element..[[ ]]..replacement)
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

			local am_langs_natural_list = require("abbrev-man.dictionaries.langs_natural.langs_natural_list").arguments
			local user_langs_natural_list = opts["natural_dictionaries"]

			if has_element(am_langs_natural_list, dict, "value") then
				for element in pairs(require("abbrev-man.dictionaries.langs_natural."..dict)) do
					map_iabbrev(element, require("abbrev-man.dictionaries.langs_natural."..dict)[element])
				end
			elseif has_element(user_langs_natural_list, dict, "value") then
				for element in pairs(user_langs_natural_list[dict]) do
					map_iabbrev(element, user_langs_natural_list[dict][element])
				end
			end

			table.insert(M.loaded_dicts, dict)
		elseif string.find(dict, "pr_") then

			local file_type = dict:gsub("pr_", "")
			local am_langs_programming_list = require("abbrev-man.dictionaries.langs_programming.langs_programming_list").arguments
			local user_langs_programming_list = opts["programming_dictionaries"]

			if has_element(am_langs_programming_list, dict, "value") then

				require("abbrev-man.utils.abbrev.modules.am_augroups").set_augroups(
					"am_"..dict,
					"BufWinEnter",
					"*."..file_type.." silent!",
					parse_iabbrev_pr(require("abbrev-man.dictionaries.langs_programming."..dict), "buffer")
				)

				local buffer_filetype = api.nvim_eval([[expand('%:e')]])
				if (buffer_filetype == file_type) then
					cmd([[]]..parse_iabbrev_pr(require("abbrev-man.dictionaries.langs_programming."..dict), "buffer")..[[]])
				end

			elseif has_element(user_langs_programming_list, dict, "value") then
				require("abbrev-man.utils.abbrev.modules.am_augroups").set_augroups(
					"am_"..dict,
					"BufWinEnter",
					"*."..file_type.." silent!",
					parse_iabbrev_pr(require("abbrev-man.dictionaries.langs_programming."..dict), "buffer")
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

	local am_langs_natural_list = require("abbrev-man.dictionaries.langs_natural.langs_natural_list").arguments
	local am_langs_programming_list = require("abbrev-man.dictionaries.langs_programming.langs_programming_list").arguments
	local user_langs_natural_list = opts["natural_dictionaries"]
	local user_langs_programming_list = opts["programming_dictionaries"]

	if has_element(M.loaded_dicts, dict, "value") then
		if string.find(dict, "nt_") then
			if has_element(am_langs_natural_list, dict, "value") then
				for element in pairs(require("abbrev-man.dictionaries.langs_natural."..dict)) do
					unmap_iabbrev(element)
				end
			elseif has_element(user_langs_natural_list, dict, "value") then
				for element in pairs(require(user_langs_natural_list[dict])) do
					unmap_iabbrev(element)
				end
			end
		elseif string.find(dict, "pr_") then
			if has_element(am_langs_programming_list, dict, "value") then
				require("abbrev-man.utils.abbrev.modules.am_augroups").unset_augroup("am_"..dict)
				for element in pairs(require("abbrev-man.dictionaries.langs_programming."..dict)) do
					unmap_iabbrev(element, "buffer")
				end
			elseif has_element(user_langs_programming_list, dict, "value") then
				require("abbrev-man.utils.abbrev.modules.am_augroups").unset_augroup("am_"..dict)
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

	local am_langs_programming_list = require("abbrev-man.dictionaries.langs_programming.langs_programming_list").arguments
	local user_langs_programming_list = opts["programming_dictionaries"]

	for u_dict in pairs(user_langs_programming_list) do

		local file_type = u_dict:gsub("pr_", "")

		if has_element(am_langs_programming_list, u_dict, "value") then
			local inner_am_dict = require("abbrev-man.dictionaries.langs_programming."..u_dict)
			for element in pairs(inner_am_dict) do
				if has_element(user_langs_programming_list[u_dict], element, "index") then
					if not (user_langs_programming_list[u_dict][element] == "rm_am") then
						inner_am_dict[element] = user_langs_programming_list[u_dict][element]
					else
						inner_am_dict[element] = nil -- remove element
					end
				end
			end

			if (option == "source") then
				require("abbrev-man.utils.abbrev.modules.am_augroups").set_augroups(
					"am_"..u_dict,
					"BufWinEnter",
					"*."..file_type.." silent!",
					parse_iabbrev_pr(inner_am_dict, "buffer")
				)

				table.insert(M.loaded_dicts, u_dict)
			end

		else
			if (option == "source") then
				require("abbrev-man.utils.abbrev.modules.am_augroups").set_augroups(
					"am_"..u_dict,
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
		if has_element(am_dicts, u_dict, "value") then

			local inner_am_dict = require("abbrev-man.dictionaries.langs_natural."..u_dict)

			for element in pairs(user_dicts[u_dict]) do
				if not has_element(inner_am_dict, element, "index") then
					inner_am_dict[element] = user_dicts[u_dict][element]
				end
			end

			for element in pairs(inner_am_dict) do
				if has_element(user_dicts[u_dict], element, "index") then
					if not (user_dicts[u_dict][element] == "rm_am") then
						vim.cmd("echo 'Seeting: "..tostring(inner_am_dict[element]).."; To: "..tostring(user_dicts[u_dict][element]).."'")
						inner_am_dict[element] = user_dicts[u_dict][element]
					else
						inner_am_dict[element] = nil -- remove element
					end
				end

				-- if has_element(inner_am_dict, )
			end

			if (option == "source") then
				for element in pairs(inner_am_dict) do
					map_iabbrev(element, inner_am_dict[element])
				end
				table.insert(M.loaded_dicts, u_dict)
			end
		else
			if (option == "source") then
				for element in pairs(user_dicts[u_dict]) do
					map_iabbrev(element, user_dicts[u_dict][element])
				end
				table.insert(M.loaded_dicts, u_dict)
			end
		end
	end
end



return M

