# open-url-by-regex.nvim

A Neovim plugin that allows you to open URLs based on regex patterns. It can transform text matching your regex patterns into URLs and open them in your default browser.

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
    'b0lle/open-url-by-regex.nvim',
    config = function()
        require('url-by-regex').setup({
            patterns = {
                {
                    pattern = "ISSUE%-(%d+)",
                    url = "https://github.com/org/repo/issues/%1"
                },
                {
                    pattern = "PR#(%d+)",
                    url = "https://github.com/org/repo/pull/%1"
                }
            }
        })
    end
}
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    'b0lle/open-url-by-regex.nvim',
    config = function()
        require('url-by-regex').setup({
            patterns = {
                {
                    pattern = "ISSUE%-(%d+)",
                    url = "https://github.com/org/repo/issues/%1"
                },
                {
                    pattern = "PR#(%d+)",
                    url = "https://github.com/org/repo/pull/%1"
                }
            }
        })
    end
}
```

## Usage

1. Configure your patterns in the setup function
2. Place your cursor on a line containing text that matches one of your patterns
3. Run the command `:URLOpenByRegex`

The plugin will find the first matching pattern in the current line and open the corresponding URL in your default browser.

## Configuration

The setup function accepts a table with the following structure:

```lua
require('url-by-regex').setup({
    patterns = {
        {
            -- Match ISSUE-123 and open https://github.com/org/repo/issues/123
            pattern = "ISSUE%-(%d+)",
            url = "https://github.com/org/repo/issues/%1"
        },
        {
            -- Match PR#456 and open https://github.com/org/repo/pull/456
            pattern = "PR#(%d+)",
            url = "https://github.com/org/repo/pull/%1"
        }
    }
})
```

Each pattern configuration consists of:

- `pattern`: A Lua regex pattern with capture groups
- `url`: The URL template where `%1`, `%2`, etc. will be replaced with the captured groups

## Examples

With the example configuration above:

- The text `ISSUE-123` will open `https://github.com/org/repo/issues/123`
- The text `PR#456` will open `https://github.com/org/repo/pull/456`

## Testing

This plugin uses [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) for testing. To run the tests:

1. Make sure you have plenary.nvim installed
2. Run the tests with:

```bash
nvim --headless -c "PlenaryBustedDirectory tests" -c "qa"
```

## License

MIT
