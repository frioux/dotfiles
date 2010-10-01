
"{{{Auto Commands

autocmd VimEnter * set vb t_vb=

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" replace tabs with spaces
autocmd BufRead,BufWrite * if ! &bin | silent! %retab | endif

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
   au!
   autocmd BufReadPost *
            \ if expand("<afile>:p:h") !=? $TEMP |
            \   if line("'\"") > 1 && line("'\"") <= line("$") |
            \     let JumpCursorOnEdit_foo = line("'\"") |
            \     let b:doopenfold = 1 |
            \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
            \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
            \        let b:doopenfold = 2 |
            \     endif |
            \     exe JumpCursorOnEdit_foo |
            \   endif |
            \ endif
   " Need to postpone using "zv" until after reading the modelines.
   autocmd BufWinEnter *
            \ if exists("b:doopenfold") |
            \   exe "normal zv" |
            \   if(b:doopenfold > 1) |
            \       exe  "+".1 |
            \   endif |
            \   unlet b:doopenfold |
            \ endif
augroup END

autocmd BufNewFile *.pl normal i#!perljjxAuse strict;use warnings;use feature ':5.10';
autocmd BufNewFile *.pm normal ipackage ;use strict;use warnings;use feature ':5.10';

"}}}

"{{{Misc Settings

" Necessary  for lots of cool vim things
set nocompatible

" This shows what you are typing as a command.  I love this!
set showcmd

" Needed for Syntax Highlighting and stuff
filetype on
filetype plugin on
syntax enable

" Who doesn't like autoindent?
set autoindent

" Spaces are better than a tab character
set expandtab

" Who wants an 8 character tab?  Not me!
set sw=3
set ts=3

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

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

" This is totally awesome - remap jj to escape in insert mode.  You'll never type jj anyway, so it's great!
inoremap jj <Esc>

nnoremap JJJJ <Nop>

" Incremental searching is sexy
set incsearch

" Highlight things that we find with the search
set hlsearch

" Since I use Linux, I want this
let g:clipbrdDefaultReg = '+'

" allow selection of nothing
set virtualedit=block
" }}}

"{{{Look and Feel

" Favorite Color Scheme
colorscheme inkpot

if has("gui_running")
   " Remove Toolbar
   set guioptions=
   if has('win32')
      set guifont=Consolas:h8
   else
      set guifont=Terminus\ 8
   endif
endif

"Status line gnarliness
set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}\ [%l,%v][%p%%]

" }}}

"{{{ Functions

function! Pivot(outer1, pivot, outer2)
   let valset = "\\(\\s\\*\\)\\(\\S\\*\\)\\(\\s\\*\\)"
   let regex = "\\M" . a:outer1 . valset . a:pivot . valset . a:outer2
   let result = a:outer1 . "\\1\\5\\3" . a:pivot . "\\4\\2\\6" .a:outer2
   let cmd = "s/" . regex . "/" . result . "/"
   exec cmd
endfunction

function! PFatComma()
   call Pivot("", "=>", ",")
endfunction

function! PCommaParen()
   call Pivot("(", ",", ")")
endfunction

function! PVMatch(match)
   exec '"ay'
   call Pivot(a:match, @a, a:match)
endfunction

vnoremap <silent> <F6> :PVMatch(",")<CR>

"{{{ Mappings

" Open NERDTree <F2>
nnoremap <silent> <F2> :NERDTreeToggle<CR>

" Workaround to repeat commands <F3>
nnoremap <silent> <F3> :let @@ = @: <Bar> exe @@<CR>

" Paste Mode!  Dang! <F10>
nnoremap <silent> <F10> :call Paste_on_off()<CR>
set pastetoggle=<F10>

" Edit vimrc \ev
nnoremap <silent> <Leader>ev :tabnew<CR>:e ~/.vimrc<CR>

" Up and down are more logical with g..
nnoremap <silent> k gk
nnoremap <silent> j gj

" Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz

noremap ,k <C-W>k
noremap ,j <C-W>j
noremap ,h <C-W>h
noremap ,l <C-W>l
noremap ,p <C-W>p
noremap ,o <C-W>o

" Testing
set completeopt=longest,menuone,preview

inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"

" Swap ; and :  Convenient.
noremap : ;
noremap! : ;
noremap ; :
noremap! ; :

iunmap :
iunmap ;

"}}}

set listchars=tab:▸\ ,eol:¬
set list

