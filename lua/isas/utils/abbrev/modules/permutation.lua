

local M = {}

function M.permgen (a, n)
    if n == 0 then
        coroutine.yield(a)
    else
        for i = 1, n, 1 do --i can't be equal to 0, cuz array will be out of index

          -- put i-th element as the last one
            a[n], a[i] = a[i], a[n]

          -- generate all permutations of the other elements
            M.permgen(a, n - 1)

          -- restore i-th element
            a[n], a[i] = a[i], a[n]
        end
    end
end

function M.perm (a)
    local n = #a
    local co = coroutine.create(function () M.permgen(a, n) end)
    return function ()   -- iterator
        local status, res = coroutine.resume(co)
        return res
    end
end



return M

