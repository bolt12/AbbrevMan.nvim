

local M = {}

local opts = require("isas.config").options
local user_dicts = opts["dictionaries"]
local isas_dicts = {"en", "es", "pt"}

-- local function has_element(table, val)
local function has_element(table, element, type)
	if (type == "value") then
		for index, value in ipairs(table) do
			if value == element then return true end
		end
	elseif (type == "index") then
		for index, value in ipairs(table) do
			-- vim.cmd("echo 'index = "..index.."; value = "..value.."'")
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
				vim.cmd("echo 'Element = "..element.."; replacement = "..inner_isas_dict[element].."'")
				vim.cmd("echo 'U dict = "..tostring(user_dicts[u_dict]).."'")
				-- for val in pairs(user_dicts[u_dict]) do
				-- 	vim.cmd("echo 'val = "..val.."'")
				-- end


				for index, value in ipairs(user_dicts[u_dict]) do
					vim.cmd("echo 'index = "..index.."; value = "..value.."'")
					-- if index == element then return true end
				end





				if has_element(user_dicts[u_dict], element, "index") then
					vim.cmd("echo 'Element in user dict = "..user_dicts[u_dict][element].."aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'")
					-- if not (user_dicts[u_dict][element] == "rm_isas") then
					-- 	inner_isas_dict[element] = user_dicts[u_dict][element]
					-- else
					-- 	table.remove(inner_isas_dict, element)
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



