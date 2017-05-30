" Favorite Color Scheme
set background=dark

" Remove Toolbar
set guioptions=

" Set the normal font face and size.
function! FontNormal()
  if has("gui_win32")
    set guifont=Consolas:h11
  else
    set guifont=Terminus\ 14
  endif
  set lines=999 columns=999             " Maximize the window
endfunction

" Increase/decrease font size.
function! FontSmaller()
  if has('win32') || has('win64')
    let &guifont = substitute(&guifont, ':h\(\d\+\)', '\=":h" . (submatch(1) - 1)', '')
  else
    let &guifont = substitute(&guifont, ' \(\d\+\)', '\=" " . (submatch(1) - 1)', '')
  endif
  set lines=999 columns=999
endfunction

function! FontBigger()
  if has('win32') || has('win64')
    let &guifont = substitute(&guifont, ':h\(\d\+\)', '\=":h" . (submatch(1) + 1)', '')
  else
    let &guifont = substitute(&guifont, ' \(\d\+\)', '\=" " . (submatch(1) + 1)', '')
  endif
endfunction

nnoremap <leader>0 :call FontNormal()<cr>
nnoremap <leader>- :call FontSmaller()<cr>
nnoremap <leader>_ :call FontSmaller()<cr>
nnoremap <leader>= :call FontBigger()<cr>
nnoremap <leader>+ :call FontBigger()<cr>

call FontNormal()
