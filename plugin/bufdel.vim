" nvim-bufdel
" By Olivier Roques
" github.com/ojroques

if exists('g:loaded_bufdel')
  finish
endif

command! -nargs=? -bang -complete=buffer BufDel
      \ lua require('bufdel').delete_buffer_expr(<q-args>, '<bang>' == '!')
command! -bang BufDelOthers
      \ lua require('bufdel').delete_buffer_others('<bang>' == '!')
command! -bang BufDelAll
      \ lua require('bufdel').delete_buffer_all('<bang>' == '!')

let g:loaded_bufdel = 1
