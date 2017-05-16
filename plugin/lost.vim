" lost.vim - I'm all lost in this file
" Maintainer:   Arthur Axel fREW Schmidt <https://blog.afoolishmanifesto.com/>
" Version:      0.9

if exists('g:loaded_lost') || &cp || v:version < 700
  finish
endif
let g:loaded_lost = 1

function! Lost_string()
  " https://git.savannah.gnu.org/cgit/diffutils.git/tree/src/diff.c?id=eaa2a24#n464
  let re = get(b:, 'lost_regex', '\v^[[:alpha:]$_]')
  let found = search(re, "bn", 1, 100)
  if found > 0
     let line = getline(found)
     return line
  else
     return '?'
  endif
endfunction
command! -bar Lost echom Lost_string()

nnoremap <silent> gL :Lost<Cr>
