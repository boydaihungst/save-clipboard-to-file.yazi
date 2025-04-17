# save-clipboard-to-file.yazi

[Yazi](https://github.com/sxyazi/yazi) plugin to paste clipboard content to file.

## Features

- Paste clipboard content to file. You can input file name, absolute path or relative path.
- Ask to overwrite file if it exists

## Requirements

- [yazi >= 25.4.4](https://github.com/sxyazi/yazi)

## Installation

```sh
ya pack -a boydaihungst/save-clipboard-to-file
```

## Usage

### Key binding

Add this to your `keymap.toml`:

```toml
[manager]
  prepend_keymap = [
    { on = [ "p", "c" ], run = "plugin save-clipboard-to-file", desc = "Paste clipboard content to file and hover after created" },
    #{ on = [ "p", "c" ], run = "plugin save-clipboard-to-file -- --no-hover", desc = "Paste clipboard content to file without hover after created" },

  ]
```

### Configuration

This setup is the default configuration. You don't need to call `setup()` if you don't want to change the default configuration.
Any options not specified will use the default value.

Add this to your `init.lua`:

```lua
require("save-clipboard-to-file"):setup({
  -- Position of input file name or path dialog
	input_position = { "center", w = 70 },
	-- Position of overwrite confirm dialog
	overwrite_confirm_position = { "center", w = 70, h = 10 },
	-- Hide notify
	hide_notify = false,
})
```
