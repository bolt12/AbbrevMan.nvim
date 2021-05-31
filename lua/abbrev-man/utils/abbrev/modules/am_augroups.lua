


local M = {}

local cmd = vim.cmd


function M.set_augroups(group_name, event, pattern, command)
	cmd('augroup ' .. group_name)
	cmd('autocmd!')
	cmd('autocmd '..event..' '..pattern..' '..command..'')
	cmd('augroup END')
end

function M.unset_augroup(group_name)
	cmd('augroup ' .. group_name)
	cmd('autocmd!')
    cmd('augroup END')
end



return M

