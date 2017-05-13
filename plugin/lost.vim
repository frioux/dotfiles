" lost.vim - I'm all lost in this file
" Maintainer:   Arthur Axel fREW Schmidt <https://blog.afoolishmanifesto.com/>
" Version:      0.9

if exists('g:loaded_lost') || &cp || v:version < 700
  finish
endif
let g:loaded_lost = 1

function! s:lost()
  " https://git.savannah.gnu.org/cgit/diffutils.git/tree/src/diff.c?id=eaa2a24#n464
  let found = search('\v^[[:alpha:]$_]', "bn", 1, 100)
  if found > 0
     let line = getline(found)
     echom line
  else
     echom '?'
  endif
endfunction
command! -bar Lost call s:lost()
