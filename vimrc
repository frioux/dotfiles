if has('win32')
   let &runtimepath = substitute(&runtimepath, '\(\~\|'.$USER.'\)/vimfiles\>', '\1/.vim', 'g')
endif

runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

if has('python3')
   call pathogen#infect('bundle-python/{}')
endif

if has('lua')
   call pathogen#infect('bundle-lua/{}')
endif

if has('nvim')
   call pathogen#infect('bundle-nvim/{}')
endif

let g:deoplete#enable_at_startup = 1

"{{{Auto Commands

set formatprg=fmt\ -w80

augroup vimrc
   autocmd!

   au BufEnter * syntax sync fromstart

   au VimEnter * set vb t_vb=

   au FileType perl let b:dispatch = 'perl %'

   au FileType perl setlocal formatprg=perltidy
   au FileType go   setlocal formatprg=gofmt

   au FileType sql    setlocal commentstring=--\ %s
   au FileType sml    setlocal commentstring=(*\ %s\ *)
   au FileType racket setlocal commentstring=;\ %s
   au FileType tf     setlocal commentstring=#\ %s
   au FileType matlab setlocal commentstring=%\ %s
   au FileType muttrc setlocal keywordprg=neoman

   au BufReadPost *.rkt,*.rktl setlocal filetype=racket
   au FileType racket setlocal lisp
   au FileType racket setlocal autoindent

   au FileType markdown setlocal nowrap | let b:lost_regex = '\v^#'

   au FileType help setlocal nolist

   au BufWritePre /tmp/* setlocal noundofile
   au BufWritePre /run/shm/* setlocal noundofile
augroup END

"}}}

"{{{Misc Settings

set conceallevel=2

" PERSISTENT UNDO
set undofile

set history=10000
if has('nvim')
   set viminfo='100,\"100,n~/.nviminfo
else
   set viminfo='100,\"100,n~/.viminfo
endif

set matchpairs+=<:>

if has('termguicolors')
   set termguicolors
endif

" Necessary  for lots of cool vim things
set nocompatible

" This shows what you are typing as a command.  I love this!
set showcmd

" Needed for Syntax Highlighting and stuff
filetype on
filetype plugin on
filetype plugin indent on
syntax enable

" Who doesn't like autoindent?
set autoindent

" Spaces are better than a tab character
set expandtab

" Cool tab completion stuff
set wildmenu
set wildmode=longest,list
" Case insensitive wild menu
set wildignorecase

" Line Numbers PWN!
set number

" Ignoring case is a fun trick
set ignorecase

" And so is Artificial Intelligence!
set smartcase

" This is totally awesome - remap jk to escape in insert mode.  You'll never type jk anyway, so it's great!
inoremap jk <Esc>

" Incremental searching is sexy
set incsearch

" Highlight things that we find with the search
set hlsearch

" allow selection of nothing
set virtualedit=block

" I never use octal (or hex?) so only treat numbers like decimals
set nrformats=
" }}}

"{{{Look and Feel

if has('termguicolors') && $COLORTERM == 'truecolor'
   set termguicolors
   if len($TMUX) > 0
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
   endif
endif

if has("gui_running")
   colorscheme solarized
else
   if has('termguicolors') && &termguicolors == 1
      colorscheme solarized8_dark_high
   else
      colorscheme elflord
   endif
endif

"Status line gnarliness
set laststatus=2

" }}}

"{{{ Mappings

if has('nvim')
   tnoremap <Esc> <C-\><C-n>
   tnoremap <C-v><Esc> <Esc>
endif

" toppost
nnoremap <silent> <Leader>tp :%!top-post<CR>ggI
vnoremap <silent> <Leader>tp :!top-post<CR>

" Edit vimrc \ev
nnoremap <silent> <Leader>ev :split $MYVIMRC<CR>

" Up and down are more logical with g..
nnoremap <silent> k gk
nnoremap <silent> j gj

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
noremap N Nzz
noremap n nzz

" http://learnvimscriptthehardway.stevelosh.com/chapters/04.html
nnoremap <c-u> viwU
inoremap <c-u> <esc>viwUi

" Testing
set completeopt=longest,menuone,preview
set complete-=i

" Swap ; and :  Convenient.
nnoremap ; :
vnoremap ; :

" Make %% represent the dir of the current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

set pastetoggle=<F12>

nmap gV `[v`]
nnoremap <leader>ts    :r !date "+\%FT\%T\%:z"<CR>

vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

nnoremap <silent> <leader>DD :exe ":profile start profile.log"<cr>:exe ":profile func *"<cr>:exe ":profile file *"<cr>
nnoremap <silent> <leader>DP :exe ":profile pause"<cr>
nnoremap <silent> <leader>DC :exe ":profile continue"<cr>
nnoremap <silent> <leader>DQ :exe ":profile pause"<cr>:noautocmd wqa!<cr>

nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

"}}}

" {{{ airline settings
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

if has('win32')
   set listchars=tab:-\ ,nbsp:~
   let g:airline_left_sep = '>'
   let g:airline_right_sep = '<'
   let g:airline_symbols.linenr = ''
   let g:airline_symbols.branch = ''
   let g:airline_symbols.whitespace = '='
else
   set listchars=tab:▸\ ,nbsp:~
   let g:airline_left_sep = '▶'
   let g:airline_right_sep = '◀'
   let g:airline_symbols.linenr = '␤'
   let g:airline_symbols.branch = '⎇ '
   let g:airline_symbols.whitespace = 'Ξ'
endif
" }}}

set list

" {{{ ale settings
"
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

" }}}

" {{{ ctrlp settings

function! DirCtrlP()
   let g:ctrlp_working_path_mode = 0
   CtrlP
endfunction

function! FileRelCtrlP()
   let g:ctrlp_working_path_mode = 'c'
   CtrlP
endfunction

let g:ctrlp_abbrev = {
  \   "abbrevs": [
  \    {
  \       "pattern": "^lib:",
  \       "expanded": "^lib/"
  \    },
  \    {
  \       "pattern": "^t:",
  \       "expanded": "^t/"
  \    }
  \   ]
  \ }

" put ctrlp matcher on top, ordering top to bottom
let g:ctrlp_match_window = 'top,order:ttb,min:5,max:30'
" search with regexen by default
let g:ctrlp_regexp = 1

if filereadable($HOME . "/.fzf/README.md")
   set rtp+=~/.fzf

   " call denite#custom#option('_', 'direction', 'aboveleft')
   nnoremap <silent> <F3> :FZF<CR>

   nnoremap <silent> <F4> :call fzf#run({'dir': expand("%:h")})<CR>

   nnoremap <silent> <F5> :call fzf#run({'source': map(range(1, bufnr('$')), 'bufname(v:val)'), 'sink': 'e', 'down': '30%'})<CR>
endif

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_use_caching = 0

" }}}
let g:jshintprg="hint"

" hopefully can get these into unimpaired
" (https://github.com/tpope/vim-unimpaired/issues/63)
nnoremap [oy :setlocal syntax=on<cr>
nnoremap ]oy :setlocal syntax=off<cr>
nnoremap coy :if &syntax != "off" \| setlocal syntax=off \| else \| setlocal syntax=on \| endif<CR>

nnoremap [oM :Matchmaker<cr>
nnoremap ]oM :Matchmaker!<cr>
nnoremap coM :MatchmakerToggle<CR>

nnoremap [oW :EnableWhitespace<cr>
nnoremap ]oW :DisableWhitespace<cr>
nnoremap coW :ToggleWhitespace<cr>

nnoremap [oS :ALEEnable<cr>
nnoremap ]oS :ALEDisable<cr>
nnoremap coS :ALEToggle<cr>

nnoremap [oQ :let g:qs_enable = 1<cr>
nnoremap ]oQ :let g:qs_enable = 0<cr>
nnoremap coQ :QuickScopeToggle<cr>

nnoremap [oN :NeoCompleteEnable<cr>
nnoremap ]oN :NeoCompleteDisable<cr>
nnoremap coN :NeoCompleteToggle<CR>

nnoremap [og :GitGutterEnable<cr>
nnoremap ]og :GitGutterDisable<cr>
nnoremap cog :GitGutterToggle<CR>

function! CycleColors()
   let mycolors = []
   if has('termguicolors') && &termguicolors
      let mycolors += ['solarized8_dark_high', 'solarized8_light_high']
   endif
   let mycolors += [ 'elflord', 'desert' ]
   let colordict = {}
   let index = 0
   while index < len(mycolors) - 1
      let item = mycolors[index]
      let colordict[item] = mycolors[index+1]
      let index += 1
   endwhile
   let colordict[mycolors[-1]] = mycolors[0]

   if has_key(g:, 'colors_name') && has_key(colordict, g:colors_name)
      let nextColor = colordict[g:colors_name]
   else
      let nextColor = mycolors[0]
   endif
   execute ':colorscheme ' . nextColor
endfunction
nnoremap <F12> :call CycleColors()<cr>

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1

set directory=$HOME/.vvar/swap
set undodir=$HOME/.vvar/undo

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()


let perl_no_subprototype_error = 1

function! ZRPod()
   let path = substitute(substitute(@%, '\(app/lib/\|\.pm\)', '', 'g'), '/', '::', 'g')
   let url = 'https://pod.ziprecruiter.com/?' . path
   let command = "firefox '" . url . "'"
   execute ":!" command
endfunction

command! Pod call ZRPod()
let g:qs_highlight_on_keys = [ 'f', 'F', 't', 'T' ]
command! Gdiffs cexpr system('git diff \| diff-hunk-list')
command! GLdiffs lexpr system('git diff \| diff-hunk-list')

command! CountMatches %s///gn

let g:fugitive_gitlab_domains = ['https://git.ziprecruiter.com']

command! -nargs=1 Gg :Grepper -tool git -query <args>

command! ESession execute ":tabnew | edit " . v:this_session . "x.vim | split" . v:this_session " | split " . v:this_session . "a.vim"

function! Multiple_cursors_before()
  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
  endif
endfunction

function! Multiple_cursors_after()
  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
  endif
endfunction
" vim: foldmethod=marker
