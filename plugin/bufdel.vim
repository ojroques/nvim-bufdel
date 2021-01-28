" nvim-bufdel
" By Olivier Roques
" github.com/ojroques

if exists('g:loaded_bufdel')
  finish
endif

command! -nargs=? -bang -complete=buffer BufDel
      \ lua require('bufdel').delete_buffer(<q-args>, '<bang>' == '!')

let g:loaded_bufdel = 1
