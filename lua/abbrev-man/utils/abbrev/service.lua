

local M = {}

function M.load_natural_dictionaries_at_startup(option)
	require("abbrev-man.utils.abbrev.modules.load_dictionaries").load_natural_dictionaries_at_startup(option)
end

function M.load_programming_dictionaries_at_startup(option)
	require("abbrev-man.utils.abbrev.modules.load_dictionaries").load_programming_dictionaries_at_startup(option)
end

function M.load_dict(dict)
	require("abbrev-man.utils.abbrev.modules.load_dictionaries").load_dict(dict)
end

function M.unload_dict(dict)
	require("abbrev-man.utils.abbrev.modules.load_dictionaries").unload_dict(dict)
end


return M

