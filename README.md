# nvim-bufdel

A very small Neovim plugin to improve the deletion of buffers.

Improvements:
* **Preserve the layout of windows.** Deleting a buffer will no longer close any
  window unexpectedly (see demo).
* **Cycle through buffers according to their number**
  ([configurable](#configuration)). This is especially helpful when using a
  bufferline: we get the same behavior as closing tabs in Chrome / Firefox (see
  demo).
* **Terminal buffers are deleted without prompt.**
* **Exit Neovim when last buffer is deleted** ([configurable](#configuration)).

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

## Configuration
You can pass options to the `setup()` function. Here are all options with their
default settings:
```lua
require('bufdel').setup {
  next = 'cycle',  -- or 'alternate'
  quit = true,
}
```

The `next` option is used to retrieve the next buffer to show after deleting
one. By default the plugin cycles through buffers according to their number. To
show instead the alternate buffer, set the option to `alternate`.

The `quit` option is used to decide whether or not to exit Neovim when closing
last buffer.

## Direct Integration
The plugin fits in a [single file](./lua/bufdel.lua), you can very well download
it and include it among your config files.

You can also integrate the command directly into your config. Here's a condensed
version of the plugin (minus minor improvements) in Lua:
```lua
function delete_buffer()
  local buflisted = fn.getbufinfo({buflisted = 1})
  local cur_winnr, cur_bufnr = fn.winnr(), fn.bufnr()
  if #buflisted < 2 then cmd 'confirm qall' return end
  for _, winid in ipairs(fn.getbufinfo(cur_bufnr)[1].windows) do
    cmd(string.format('%d wincmd w', fn.win_id2win(winid)))
    cmd(cur_bufnr == buflisted[#buflisted].bufnr and 'bp' or 'bn')
  end
  cmd(string.format('%d wincmd w', cur_winnr))
  local is_terminal = fn.getbufvar(cur_bufnr, '&buftype') == 'terminal'
  cmd(is_terminal and 'bd! #' or 'silent! confirm bd #')
end
```

Or in Vimscript:
```vim
function! s:delete_buffer()
  let l:buflisted = getbufinfo({'buflisted': 1})
  let [l:cur_winnr, l:cur_bufnr] = [winnr(), bufnr()]
  if len(l:buflisted) < 2 | confirm qall | return | endif
  for l:winid in getbufinfo(l:cur_bufnr)[0].windows
    execute(win_id2win(l:winid) . 'wincmd w')
    if l:cur_bufnr == l:buflisted[-1].bufnr | bp | else | bn | endif
  endfor
  execute(l:cur_winnr . 'wincmd w')
  let l:is_terminal = getbufvar(l:cur_bufnr, '&buftype') == 'terminal'
  if l:is_terminal | bd! # | else | silent! confirm bd # | endif
endfunction
```

## License
[LICENSE](./LICENSE)
