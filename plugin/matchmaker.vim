if exists('g:matchmaker_loaded') || &compatible
    finish
endif

" [ Defaults ] {{{

let s:enabled = 0
let g:matchmaker_matchpriority = get(g:, 'matchmaker_matchpriority', 10)

hi default Matchmaker term=underline    ctermbg=238     guibg=#dddddd

" }}}

" [ Functions ] {{{

" Source: http://stackoverflow.com/a/6271254/2075911
function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [line1, col1] = getpos("'<")[1:2]
  let [line2, col2] = getpos("'>")[1:2]
  let lines = getline(line1, line2)
  if len(lines)
    let lines[-1] = lines[-1][:col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
  else
    return ''
  endif
endfunction

function! s:highlight(needle)
    silent! let w:matchmaker_matchid = matchadd('Matchmaker', a:needle, g:matchmaker_matchpriority)
endfunction

function! s:matchunmake()
    "Decho "matchunmake"
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
    if mode() == 'v'
        return '\V\<'.escape(s:get_visual_selection(), '\').'\>'
    else
        "Decho 'current char under cursor: '. getline(".")[col(".")-1]
        if getline(".")[col(".")-1] =~# '\k' 
            return '\V\<'.escape(expand('<cword>'), '\').'\>'
        endif
    endif
endfunction

function! s:needle()
    return exists('*b:matchmaker_needle') ? b:matchmaker_needle() : s:default_needle()
endfunction

function! s:matchmake(needle)
    if !s:is_enabled()
        return
    endif

    if empty(a:needle)
        "Decho "Empty needle: " . a:needle
        call s:matchunmake()
        return
    endif
    "Decho "Current needle: " . a:needle

    if !s:is_new_needle(a:needle)
        return
    endif

    call s:matchunmake()
    let w:matchmaker_needle = a:needle
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
