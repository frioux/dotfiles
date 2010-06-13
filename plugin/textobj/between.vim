" textobj-between - Text objects for a range between a character.
" Version: 0.1.0
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

if exists('g:loaded_textobj_between')
  finish
endif
let g:loaded_textobj_between = 1

let s:save_cpo = &cpo
set cpo&vim


" Interface  "{{{1
call textobj#user#plugin('between', {
\      '-': {
\        '*sfile*': expand('<sfile>:p'),
\        'select-a': 'af',  '*select-a-function*': 's:select_a',
\        'select-i': 'if',  '*select-i-function*': 's:select_i',
\      }
\    })


function! s:select_a()  "{{{2
  return s:select(0)
endfunction



function! s:select_i()  "{{{2
  return s:select(1)
endfunction



function! s:select(in)  "{{{2
  let c = getchar()
  if type(c) == type(0)
    let c = nr2char(c)
  endif
  if c !~ '[[:print:]]'
    return 0
  endif

  let save_ww = &whichwrap
  set whichwrap=h,l

  try
    let pos = getpos('.')
    let pat = c == '\' ? '\\' : '\V' . c
    for i in range(v:count1)
      if !search(pat, 'bW')
        return 0
      endif
    endfor
    if a:in
      normal! l
    endif
    let start = getpos('.')

    call setpos('.', pos)
    for i in range(v:count1)
      if !search(pat, 'W')
        return 0
      endif
    endfor
    if a:in
      normal! h
    endif
    let end = getpos('.')
    return ['v', start, end]
  finally
    let &whichwrap = save_ww
  endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
