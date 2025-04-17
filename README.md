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

- Add this to your `keymap.toml`:

  ```toml
  [manager]
    prepend_keymap = [
      { on = [ "p", "c" ], run = "plugin save-clipboard-to-file", desc = "Paste clipboard content to file" },
    ]
  ```
