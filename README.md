# nvim-bufdel

A small Neovim plugin to improve the deletion of buffers.

Improvements:
* **Preserve the layout of windows.** Deleting a buffer will no longer close any
  window unexpectedly (see demo).
* **Cycle through buffers according to their number**
  ([configurable](#configuration)). This is especially helpful when using a
  bufferline: we get the same behavior as closing tabs in Chrome / Firefox (see
  demo).
* **Terminal buffers are deleted without prompt.**
* **Exit Neovim when last buffer is deleted** ([configurable](#configuration)).
* **Add commands to close all listed buffers and to close them all except the
  current one.**

![demo](https://user-images.githubusercontent.com/23409060/188604956-51b33576-df09-41f2-aead-9d3685686d3f.gif)

Here the same buffer is displayed in left and top-right window. Deleting that
buffer preserves the window layout and the first buffer with a number greater
than the deleted one is selected instead (the one immediately to the right in
the bufferline).

## Installation
With [packer.nvim](https://github.com/wbthomason/packer.nvim):
```lua
use {'ojroques/nvim-bufdel'}
```

With [paq-nvim](https://github.com/savq/paq-nvim):
```lua
paq {'ojroques/nvim-bufdel'}
```

## Usage
Delete the current buffer:
```vim
:BufDel
```

Delete the current buffer and ignore changes:
```vim
:BufDel!
```

Delete a buffer by its name or number (use quotes in case the buffer name is a
number):
```vim
:BufDel <bufexpr>
```

Delete all listed buffers (add `!` to ignore changes):
```vim
:BufDelAll
```

Delete all listed buffers except the current one (add `!` to ignore changes):
```vim
:BufDelOthers
```

## Configuration
You can pass options to the `setup()` function. Here are the default options:
```lua
require('bufdel').setup {
  next = 'tabs',  -- or 'cycle, 'alternate'
  quit = true,    -- quit Neovim when last buffer is closed
}
```

The `next` option determines the next buffer to display after deletion.
Supported values:
* `cycle`: cycle through buffers according to their number.
* `tabs` (*default*): like `cycle` but when the buffer with highest number is
  deleted, display the new highest buffer instead of going back to the first
  one.
* `alternate`: switch to the alternate buffer (same behavior as without the
  plugin).
