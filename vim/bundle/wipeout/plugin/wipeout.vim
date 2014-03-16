" wipeout.vim - Destroy all buffers that are not open in any tabs or windows.
"
" Adapted from the following StackOverflow answer:
" http://stackoverflow.com/questions/1534835
"
" Author: Artem Nezvigin <artem@artnez.com>

command! -bang Wipeout :call Wipeout(<bang>0)

function! Wipeout(bang)
  " figure out which buffers are visible in any tab
  let visible = {}
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let visible[b] = 1
    endfor
  endfor
  " close any buffer that are loaded and not visible
  let l:tally = 0
  let l:cmd = 'bw'
  if a:bang
    let l:cmd .= '!'
  endif
  for b in range(1, bufnr('$'))
    if buflisted(b) && !has_key(visible, b)
      let l:tally += 1
      exe l:cmd . ' ' . b
    endif
  endfor
  echon "Deleted " . l:tally . " buffers"
endfun
