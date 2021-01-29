# nvim-bufdel

A very small Neovim plugin to improve the deletion of buffers.

Features:
* Preserve the window layout after deleting a buffer.
* Cycle through buffers according to their buffer number, exactly like tabs in
  Chrome / Firefox. This is especially helpful when using a bufferline.
* Delete terminal buffers without being prompted.
* Exit Neovim when there is only one buffer left.

## Installation

#### With Packer
```lua
cmd 'packadd packer.nvim'
return require('packer').startup(function()
  use {'ojroques/nvim-bufdel'}
end)
```

#### With Plug
```vim
call plug#begin()
Plug 'ojroques/nvim-bufdel'
call plug#end()
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

Delete a buffer by its name or number:
```vim
:BufDel <bufexpr>
```

## License
[LICENSE](./LICENSE)
