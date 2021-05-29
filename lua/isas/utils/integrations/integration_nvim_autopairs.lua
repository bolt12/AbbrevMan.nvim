

local M = {}

function M.enable_element()
	require("nvim-autopairs").state["disabled"] = false
end

function M.disable_element()
	require("nvim-autopairs").state["disabled"] = true
end


return M

