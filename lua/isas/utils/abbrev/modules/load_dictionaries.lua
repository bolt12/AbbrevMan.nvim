

local M = {}

local opts = require("isas.config").options
-- local isas_augroups = require("isas.utils.abbrev.isas_augroups")
local isas_dicts = require("isas.completions.aa_dictionaries").arguments
local user_dicts = opts["dictionaries"]
local loaded_dicts = {}
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

-- function M.load_dict(dict)
--
-- end
--
-- function M.unload_dict(dict)
--
-- end

function M.load_at_startup()
	for u_dict in pairs(user_dicts) do
		if has_element(isas_dicts, u_dict, "value") then
		vim.cmd("echo 'Got HERE!!'")
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

			for element in pairs(inner_isas_dict) do
				map_iabbrev(element, inner_isas_dict[element])
			end
			-- table.insert(_G_loaded_dicts, u_dict)
			table.insert(loaded_dicts, u_dict)


-- 			function load_local_group()
-- 				for element in pairs(inner_isas_dict) do
-- 					map_iabbrev(element, inner_isas_dict[element])
-- 				end
-- 			end
--
-- 			isas_augroups.set_augroups(
-- 				'ISAS_'..u_dict,
-- 				'BufWinEnter',
-- 				'*',
-- 				'execute "lua load_local_group()"'
-- 			)

				-- 'execute "load_local_group()"'

			-- vim.api.nvim_exec([[
			-- 	augroup ISAS_en
			-- 		autocmd!
			-- 		autocmd BufWinEnter * echo "hello"
			-- 	augroup END
			-- ]], false)

			-- for element in pairs(inner_isas_dict) do
			-- 	map_iabbrev(element, inner_isas_dict[element])
			-- end
		else
			vim.cmd("echo 'Got HEREEEEEEEEEEEEEEEEEEEEE!!'")
			for element in pairs(user_dicts[u_dict]) do
				map_iabbrev(element, user_dicts[u_dict][element])
			end
			table.insert(loaded_dicts, u_dict)
		end
	end


	for dict in pairs(loaded_dicts) do
		vim.cmd("echo 'Dict = "..dict.."'")
	end

end



return M



