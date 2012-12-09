" textobj-between - Text objects for a range between a character.
" Version: 0.2.0
" Author : thinca <thinca+vim@gmail.com>
" License: zlib License

if exists('g:loaded_textobj_between')
  finish
endif
let g:loaded_textobj_between = 1

let s:save_cpo = &cpo
set cpo&vim

" Interface  "{{{1
call textobj#user#plugin('between', {
\      '-': {
\        'select-a': 'af',  '*select-a-function*': 'textobj#between#select_a',
\        'select-i': 'if',  '*select-i-function*': 'textobj#between#select_i',
\      }
\    })


let &cpo = s:save_cpo
unlet s:save_cpo
