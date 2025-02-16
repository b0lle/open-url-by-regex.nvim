local M = {}

-- Default configuration
M.config = {
	patterns = {
		-- Example pattern: {pattern = "ISSUE%-(%d+)", url = "https://github.com/org/repo/issues/%1"}
	},
}

-- Setup function to be called by users
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Function to open URL with the system's default browser
local function open_url(url)
	local cmd

	vim.ui.open(url)

	vim.fn.jobstart(cmd, {
		on_exit = function(_, code)
			if code ~= 0 then
				vim.notify("Failed to open URL: " .. url, vim.log.levels.ERROR)
			end
		end,
	})
end

-- Main function to handle URL opening based on regex
function M.open_url_by_regex()
	local current_line = vim.api.nvim_get_current_line()

	for _, pattern_config in ipairs(M.config.patterns) do
		local matches = { string.match(current_line, pattern_config.pattern) }

		if #matches > 0 then
			local url = pattern_config.url
			-- Replace capture groups in URL using a single gsub with a function
			url = url:gsub("%%(%d+)", function(n)
				return matches[tonumber(n)] or ""
			end)
			open_url(url)
			return
		end
	end

	vim.notify("No matching pattern found in current line", vim.log.levels.WARN)
end

return M
