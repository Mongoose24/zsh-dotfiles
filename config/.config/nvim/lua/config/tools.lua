local M = {}

function M.executable(command)
	return vim.fn.executable(command) == 1
end

function M.has_compiler()
	return M.executable("cc") or M.executable("gcc") or M.executable("clang")
end

function M.tree_sitter_supported()
	if not M.executable("tree-sitter") then
		return false, nil
	end

	local output = vim.fn.system({ "tree-sitter", "--version" })
	if vim.v.shell_error ~= 0 then
		return false, vim.trim(output)
	end

	local major, minor, patch = output:match("(%d+)%.(%d+)%.(%d+)")
	if not major then
		return false, vim.trim(output)
	end

	major, minor, patch = tonumber(major), tonumber(minor), tonumber(patch)
	local supported = major > 0 or major == 0 and (minor > 26 or minor == 26 and patch >= 1)
	return supported, ("%d.%d.%d"):format(major, minor, patch)
end

return M
