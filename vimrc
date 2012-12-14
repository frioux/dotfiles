
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

if has('win32')
   let &runtimepath = substitute(&runtimepath, '\(\~\|'.$USER.'\)/vimfiles\>', '\1/.vim', 'g')
endif

"{{{Auto Commands

autocmd VimEnter * set vb t_vb=

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin && ! &readonly && expand('<afile>:p') !~ '\.git/' | silent! %s/\s\+$//ge | endif

" replace tabs with spaces
autocmd BufRead,BufWrite * if ! &bin && ! &readonly && expand('<afile>:p') !~ '\.git/' | silent! %retab | endif

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

set viminfo='10,\"100,:20,%,n~/.viminfo

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

" }}}

"{{{ Mappings

" Open NERDTree <F2>
nnoremap <silent> <F2> :NERDTreeToggle<CR>

" fmt
nnoremap <silent> <Leader>fm :.!fmt -w80<CR>
vnoremap <silent> <Leader>fm :!fmt -w80<CR>

" perltidy
nnoremap <silent> <Leader>pt :%!perltidy<CR>
vnoremap <silent> <Leader>pt :!perltidy<CR>

" Edit vimrc \ev
nnoremap <silent> <Leader>ev :tabnew<CR>:e ~/.vimrc<CR>

" DwarnF a perl var
vnoremap <silent> <Leader>d= :!dwarnf_var_assignment<CR>
nnoremap <silent> <Leader>d= :.!dwarnf_var_assignment<CR>

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

" Testing
set completeopt=longest,menuone,preview
set complete-=i

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

nnoremap <F1> :GundoToggle<CR>
inoremap <F1> :GundoToggle<CR>

"}}}

if has('win32')
   set listchars=tab:-\ ,eol:$
   set directory=~/var/swap
   set undodir=~/var/undo
else
   set listchars=tab:▸\ ,eol:¬
   set directory=~/.vim/var/swap
   set undodir=~/.vim/var/undo
endif

set list

" {{{ FuzzyFinder settings

let g:fuf_abbrevMap = {
     \   "^lib:" : [
     \     "cgi/My/**/",
     \     "App/lib/**/",
     \   ],
     \   "^c:" : [ "App/lib/Lynx/Controller/**/" ],
     \   "^js:" : [
     \     "cgi/js/",
     \     "cgi/js/ui/**/",
     \     "cgi/js/record/**/",
     \     "cgi/js/fn/**/",
     \   ],
     \   "^t:" : [
     \     "t/",
     \     "t/**/",
     \   ],
     \ }

nnoremap <silent> <F3> :FufFile<CR>
nnoremap <silent> <S-F3> :FufRenewCache<CR>
nnoremap <silent> <F4> :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> <F5> :FufBuffer<CR>
nnoremap <silent> <F6> :FufLine<CR>

" }}}
let g:jshintprg="hint"
" vim: foldmethod=marker
