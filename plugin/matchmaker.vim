if exists('g:matchmaker_loaded') || &compatible
    finish
endif

" [ Defaults ] {{{

let s:enabled = 0
let s:matchpriority = 10

hi default Matchmaker term=underline    ctermbg=238     guibg=#dddddd

" }}}

" [ Functions ] {{{

function! s:highlight(needle)
    silent! let w:matchmaker_matchid = matchadd('Matchmaker', a:needle, s:matchpriority)
endfunction

function! s:matchunmake()
    if exists('w:matchmaker_needle')
        unlet w:matchmaker_needle
    endif
    if exists('w:matchmaker_matchid')
        silent! call matchdelete(w:matchmaker_matchid)
        unlet w:matchmaker_matchid
    endif
endfunction

function! s:enable(enabled)
    let s:enabled = a:enabled
    if !s:enabled
        call s:matchunmake()
    else
        call s:matchmake(s:needle())
    endif
endfunction

function! s:is_enabled()
    return exists('s:enabled') && s:enabled
endfunction

function! s:is_new_needle(needle)
    if !exists('w:matchmaker_needle')
        return 1
    else
        return !(a:needle ==# w:matchmaker_needle)
    endif
endfunction

function! s:default_needle()
    return '\V\<'.escape(expand('<cword>'), '\').'\>'
endfunction

function! s:needle()
    return exists('*b:matchmaker_needle') ? b:matchmaker_needle() : s:default_needle()
endfunction

function! s:matchmake(needle)
    if !s:is_enabled()
        return
    elseif s:is_new_needle(a:needle)
        if empty(a:needle)
            call s:matchunmake()
            return
        endif
        call s:matchunmake()
        let w:matchmaker_needle = a:needle
    else
        return
    endif
    call s:highlight(w:matchmaker_needle)
endfunction

function! s:toggle()
    if s:is_enabled()
        call s:enable(0)
    else
        call s:enable(1)
    endif
endfunction

" }}}

" [ Commands ] {{{

command! -bang -nargs=0 Matchmaker call s:enable(<bang>1)
command! -nargs=0 MatchmakerToggle call s:toggle()

" }}}

" [ Autocmds ] {{{

augroup Matchmaker
    au!
    au CursorMoved,CursorMovedI,WinEnter,VimEnter * call s:matchmake(s:needle())
    au WinLeave * call s:matchunmake()
augroup END

" }}}

" [ Enable on start ] {{{

if exists('g:matchmaker_enable_startup') && g:matchmaker_enable_startup
    Matchmaker
endif

" }}}
