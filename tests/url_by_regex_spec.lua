local plugin = require("url-by-regex")

describe("url-by-regex", function()
	-- Setup and teardown
	before_each(function()
		-- Reset the configuration before each test
		plugin.setup({
			patterns = {
				{
					pattern = "ISSUE%-(%d+)",
					url = "https://github.com/org/repo/issues/%1",
				},
				{
					pattern = "PR#(%d+)",
					url = "https://github.com/org/repo/pull/%1",
				},
				{
					pattern = "JIRA%-(%w+)%-(%d+)",
					url = "https://jira.company.com/browse/%1-%2",
				},
			},
		})
	end)

	-- Mock functions
	local urls_opened = {}
	local notifications = {}

	before_each(function()
		-- Reset our test tracking variables
		urls_opened = {}
		notifications = {}

		-- Mock vim.fn.jobstart
		_G.vim = _G.vim or {}
		_G.vim.fn = _G.vim.fn or {}
		_G.vim.fn.jobstart = function(cmd)
			if type(cmd) == "table" then
				table.insert(urls_opened, cmd[#cmd])
			end
			return 0
		end

		-- Mock vim.notify
		_G.vim.notify = function(msg, level)
			table.insert(notifications, { message = msg, level = level })
		end

		-- Mock vim.api.nvim_get_current_line
		_G.vim.api = _G.vim.api or {}
		_G.vim.api.nvim_get_current_line = function()
			return current_line
		end
	end)

	-- Test cases
	it("should open GitHub issue URL", function()
		current_line = "Fix ISSUE-123 before release"
		plugin.open_url_by_regex()
		assert.equals(urls_opened[1], "https://github.com/org/repo/issues/123")
	end)

	it("should open PR URL", function()
		current_line = "Review PR#456 please"
		plugin.open_url_by_regex()
		assert.equals(urls_opened[1], "https://github.com/org/repo/pull/456")
	end)

	it("should handle multiple capture groups", function()
		current_line = "Working on JIRA-PROJECT-789"
		plugin.open_url_by_regex()
		assert.equals(urls_opened[1], "https://jira.company.com/browse/PROJECT-789")
	end)

	it("should notify when no pattern matches", function()
		current_line = "This line has no matching patterns"
		plugin.open_url_by_regex()
		assert.equals(notifications[1].message, "No matching pattern found in current line")
		assert.equals(#urls_opened, 0)
	end)

	it("should handle multiple matches in config but use first match", function()
		current_line = "ISSUE-123 and PR#456"
		plugin.open_url_by_regex()
		assert.equals(urls_opened[1], "https://github.com/org/repo/issues/123")
		assert.equals(#urls_opened, 1) -- Should only open one URL
	end)

	it("should handle empty line", function()
		current_line = ""
		plugin.open_url_by_regex()
		assert.equals(notifications[1].message, "No matching pattern found in current line")
		assert.equals(#urls_opened, 0)
	end)
end)
