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

   au VimEnter * set vb t_vb=

   au FileType perl let b:dispatch = 'perl %'

   au FileType perl setlocal formatprg=perltidy
   au FileType go   setlocal formatprg=gofmt

   au FileType sml    setlocal commentstring=(*\ %s\ *)
   au FileType racket setlocal commentstring=;\ %s
   au FileType tf     setlocal commentstring=#\ %s

   au BufReadPost *.rkt,*.rktl setlocal filetype=racket
   au FileType racket setlocal lisp
   au FileType racket setlocal autoindent

   au FileType markdown let b:lost_regex = '\v^#'

   au FileType help setlocal nolist
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

" Who wants an 8 character tab?  Not me!
set sw=3
set ts=3

set tw=80

" Cool tab completion stuff
set wildmenu
set wildmode=full
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

if has("gui_running")
   colorscheme solarized
else
   if &t_Co == 256
      colorscheme inkpot
   else
      colorscheme elflord
   endif
endif

"Status line gnarliness
set laststatus=2

" }}}

"{{{ Mappings

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

" {{{ syntastic settings
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
\ "mode": "active",
\ "passive_filetypes": ["perl"] }
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
nnoremap <silent> <F3> :call DirCtrlP()<CR>
nnoremap <silent> <S-F3> :CtrlPClearCache<CR>
nnoremap <silent> <F4> :call FileRelCtrlP()<CR>
nnoremap <silent> <F5> :CtrlPBuffer<CR>

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_use_caching = 0

" }}}
let g:jshintprg="hint"

" hopefully can get these into unimpaired
" (https://github.com/tpope/vim-unimpaired/issues/63)
nnoremap [oy :setlocal syntax=on<cr>
nnoremap ]oy :setlocal syntax=off<cr>
nnoremap coy :if exists("g:syntax_on") \| setlocal syntax=off \| else \| setlocal syntax=on \| endif<CR>

nnoremap [oM :Matchmaker<cr>
nnoremap ]oM :Matchmaker!<cr>
nnoremap coM :MatchmakerToggle<CR>

nnoremap [oW :EnableWhitespace<cr>
nnoremap ]oW :DisableWhitespace<cr>
nnoremap coW :ToggleWhitespace<cr>

nnoremap [oS :let b:syntastic_mode = 'active'<cr>
nnoremap ]oS :let b:syntastic_mode = 'passive'<cr>
nnoremap coS :SyntasticToggleMode<cr>

nnoremap [oQ :let g:qs_enable = 1<cr>
nnoremap ]oQ :let g:qs_enable = 0<cr>
nnoremap coQ :QuickScopeToggle<cr>

nnoremap [oN :NeoCompleteEnable<cr>
nnoremap ]oN :NeoCompleteDisable<cr>
nnoremap coN :NeoCompleteToggle<CR>

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

" vim: foldmethod=marker
