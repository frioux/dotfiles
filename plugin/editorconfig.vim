" editorconfig
" Version: 0.6.0
" Author: sgur
" License: MIT License

if exists('g:loaded_editorconfig')
  finish
endif
let g:loaded_editorconfig = 1

let s:save_cpo = &cpo
set cpo&vim

" g:editorconfig_root_chdir : 1 or 0 (default)
let g:editorconfig_root_chdir = get(g:, 'editorconfig_root_chdir', 0)

" g:editorconfig_blacklist : {'filetype': [], 'pattern': []} (default)
let g:editorconfig_blacklist = get(g:, 'editorconfig_blacklist', {})

" g:editorconfig_local_vimrc : 1 or 0 (default)
let g:editorconfig_local_vimrc = get(g:, 'editorconfig_local_vimrc', 0)

augroup plugin-editorconfig
  autocmd!
  autocmd BufNewFile,BufReadPost * nested  call editorconfig#load()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
