


local M = {}

local cmd = vim.cmd


function M.set_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        cmd('augroup ' .. group_name)
        cmd('autocmd!')

        for _, def in pairs(definition) do
            local command = table.concat(vim.tbl_flatten {'autocmd', def}, ' ')
            cmd(command)
        end

        cmd('augroup END')
    end
end

function M.unset_augroup(group_name)
	cmd('augroup ' .. group_name)
	cmd('autocmd!')
    cmd('augroup END')
end



return M

