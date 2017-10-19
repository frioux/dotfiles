if exists("g:loaded_regedit")
  finish
endif
let g:loaded_regedit = 1

function! s:lengthCmp(a, b)
   return len(a:b) - len(a:a)
endfunction

let g:RegEdit_default_keycodes = { "\<CR>": '\\<CR>', "\<BS>": '\\<BS>', "\<Tab>": '\\<Tab>', "\<Esc>": '\\<Esc>' }
function! s:tidy(str)
   let ret = a:str

   let keycodes = g:RegEdit_default_keycodes

   if has_key(g:, 'RegEdit_keycodes')
      let keycodes = g:RegEdit_keycodes
   endif

   for code in sort(keys(keycodes), 's:lengthCmp')
      let ret = substitute(ret, code, keycodes[code], "g")
   endfor
   return ret
endfunction

function! RegEditRHS(which)
   return s:tidy(escape(getreg(a:which), '"\'))
endfunction

function! RegEdit(which)
   return 'let @' . a:which . ' = "' . RegEditRHS(a:which) . '"'
endfunction

nnoremap <silent> <Plug>RegEdit :<c-r>=RegEdit(nr2char(getchar()))<cr>
if !hasmapto('<Plug>RegEdit') && mapcheck('<leader>E', 'n') ==# ''
   nmap <leader>E <Plug>RegEdit
endif
