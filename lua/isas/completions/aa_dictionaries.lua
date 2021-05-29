

local M = {}

M.arguments = {
	["nt_en"] = "nt_en",
	["nt_es"] = "nt_es",
	["nt_pt"] = "nt_pt"
}

function M.available_commands()
	return vim.tbl_keys(M.arguments)
end



return M

