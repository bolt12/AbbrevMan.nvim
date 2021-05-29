

local M = {}

M.arguments = {
	en = "en",
	es = "es",
	pt = "pt"
}

function M.available_commands()
	return vim.tbl_keys(M.arguments)
end



return M

