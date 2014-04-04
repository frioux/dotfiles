" dispatch.vim GNU Screen strategy

if exists('g:autoloaded_dispatch_screen')
  finish
endif
let g:autoloaded_dispatch_screen = 1

function! dispatch#screen#handle(request) abort
  if empty($STY) || !executable('screen')
    return 0
  endif
  if a:request.action ==# 'make'
    if !get(a:request, 'background', 0) && empty(v:servername)
      return 0
    endif
    return dispatch#screen#spawn(dispatch#prepare_make(a:request), a:request)
  elseif a:request.action ==# 'start'
    return dispatch#screen#spawn(dispatch#prepare_start(a:request), a:request)
  endif
endfunction

function! dispatch#screen#spawn(command, request) abort
  let command = 'screen -ln -fn -t '.dispatch#shellescape(a:request.title)
        \ . ' ' . &shell . ' ' . &shellcmdflag . ' '
        \ . shellescape('exec ' . dispatch#isolate(['STY', 'WINDOW'],
        \ dispatch#set_title(a:request), a:command))
  silent execute '!' . escape(command, '!#%')
  if a:request.background
    silent !screen -X other
  endif
  return 1
endfunction
