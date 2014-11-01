if has('win32')
   let &runtimepath = substitute(&runtimepath, '\(\~\|'.$USER.'\)/vimfiles\>', '\1/.vim', 'g')
endif

runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

if has('python')
   call pathogen#infect('bundle-python/{}')
endif

if has('lua')
   call pathogen#infect('bundle-lua/{}')
endif


"{{{Auto Commands

autocmd VimEnter * set vb t_vb=

" Restore cursor position to where it was before
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

"}}}

"{{{Misc Settings

" PERSISTENT UNDO
set undofile

set history=10000
set viminfo='10,\"100,:10000,%,n~/.viminfo

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
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

" Enable mouse support in console
set mouse=a

" Got backspace?
set backspace=2

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

" Since I use Linux, I want this
let g:clipbrdDefaultReg = '+'

" allow selection of nothing
set virtualedit=block

" I never use octal (or hex?) so only treat numbers like decimals
set nrformats=
" }}}

"{{{Look and Feel

if has("gui_running")
   " Favorite Color Scheme
   set background=dark
   colorscheme solarized

   " Remove Toolbar
   set guioptions=
   if has('win32')
      set guifont=Consolas:h8
   else
      set guifont=Terminus\ 8
   endif
else
   if &t_Co == 256
      colorscheme inkpot
   else
      colorscheme elflord
   endif
endif

"Status line gnarliness
set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}\ [%l,%v][%p%%]

highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

" }}}

"{{{ Mappings

" toppost
nnoremap <silent> <Leader>tp :%!top-post<CR>ggI
vnoremap <silent> <Leader>tp :!top-post<CR>

" Edit vimrc \ev
nnoremap <silent> <Leader>ev :split $MYVIMRC<CR>

" DwarnF a perl var
vnoremap <silent> <Leader>d= :!dwarnf_var_assignment<CR>
nnoremap <silent> <Leader>d= :.!dwarnf_var_assignment<CR>

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

inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"

" Swap ; and :  Convenient.
nnoremap ; :
vnoremap ; :

" make : work with Sneak
map : <Plug>SneakNext

" Make %% represent the dir of the current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

nnoremap <F10> :split<CR>
nnoremap <F11> :vsplit<CR>
set pastetoggle=<F12>

nmap gV `[v`]
nnoremap <leader>ts    :r !date "+\%FT\%T\%:z"<CR>

vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

map q: :q

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

augroup formatprg
   au FileType * set formatprg=fmt\ -w80
   au FileType perl set formatprg=perltidy
   au FileType go set formatprg=gofmt
augroup end

nmap gs <Plug>Sneak_s
nmap gS <Plug>Sneak_S
xmap gs <Plug>Sneak_s
xmap gS <Plug>Sneak_S
omap gs <Plug>Sneak_s
omap gS <Plug>Sneak_S

" hopefully can get these into unimpaired
" (https://github.com/tpope/vim-unimpaired/issues/63)
nnoremap [oy :syntax on<cr>
nnoremap ]oy :syntax off<cr>
nnoremap coy :if exists("g:syntax_on") \| syntax off \| else \| syntax enable \| endif<CR>

nnoremap [oM :Matchmaker<cr>
nnoremap ]oM :Matchmaker!<cr>
nnoremap coM :MatchmakerToggle<CR>

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

autocmd FileType sml set commentstring=(*\ %s\ *)
autocmd FileType racket set commentstring=;\ %s

autocmd BufReadPost *.rkt,*.rktl set filetype=racket
autocmd FileType racket set lisp
autocmd FileType racket set autoindent

" vim: foldmethod=marker
