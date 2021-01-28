" nvim-bufdel
" By Olivier Roques
" github.com/ojroques

if exists('g:loaded_bufdel')
  finish
endif

command! BufDel lua require('bufdel').delete_buffer()

let g:loaded_bufdel = 1
