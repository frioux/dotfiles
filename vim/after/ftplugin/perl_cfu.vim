set debug=msg
" example of use for ctags:
" ctags --languages=perl -f ~/local/var/ctags/perl/INC -R ` perl -E '-d && /../ && say for @INC'`

let g:perl_use_sub = {}
set isk+=:
" find all modules in the current file
nnoremap ,r :call PerlRefreshSubs()<cr>

function! CtagsForShellCmd ()
    return join(filter(split(&tags,','),'filereadable(v:val)'),' ')
endfunction

function! PerlModuleKeepHead(base,list)
    let r = {}
    let matches_module_tail= "'^" . a:base . "[^:]*::\\zs.*'"
    " let removes_module_tail = 'let r[substitute(v:val,'.matches_module_tail.',"","")]=1'
    " call map(a:list,removes_module_tail)
    let removes_module_tail = 'substitute(v:val,'.matches_module_tail.',"","")'
    for f in map(a:list,removes_module_tail)
        let r[f]=1
    endfor
    return keys(r)
endfunction

" the completion function itself
set cfu=Perlcfu
function! Perlcfu ( findstart, base )
    let line = getline('.')

    if a:findstart
	" first use ( see :h complete-functions )
	"
	" the completion starts when the previous char is not a char from &isk
	" for exemple $toto->|foo
	" | is the start of the completion because > is not an &isk (\k regex)
	let start  = col('.')-1
	while start > 0
	    let previous = start - 1 
	    if line[ previous ] !~ '\k'
		let g:perlcfu = previous
		return start
	    endif
	    let start -= 1
	endwhile
	let g:perlcfu = 0
	return 0
    else
	" second use ( see :h complete-functions )
	" now the completion itself

	let start_with_base = "v:val =~ '^". a:base . "'"

	" the word to complete is just after ->
	if line[g:perlcfu] == '>' && line[g:perlcfu - 1]  == '-'
	    " then it's a method, only complete with subs
	    return filter( keys(g:perl_use_sub), start_with_base )
	else
	    " else it can be a module (calling a constructor)
	    let g:result =  PerlModuleKeepHead( a:base,  filter( copy(g:perl_use_module), start_with_base )) 
	    " start of instruction             : %(^|[;{])\s* 
	    " that is use or require           :  <%(use|require)>\s+ 
	    " just before the word to complete : \%cg:perlcfu
	    if line !~ '\v%(^|[;{])\s*<%(use|require)>\s+\%c'.g:perlcfu
		" didn't match ? so it's not a use or require command :)
		" add the subs
		let g:result +=  filter( keys(g:perl_use_sub), start_with_base )
	    endif
	    return g:result
	end
    endif
endfunction

function! PerlListModules ()
    let module = {} 
    let shell_script = "awk '/p$/ { print $1 }' " . CtagsForShellCmd()
    for name in split( system( shell_script ), '\n' )
	let module[name] = 1 
    endfor
    return keys(module)
endfunction

" module name to relative path
function! PerlModuleToRPath (module)
     return substitute( a:module, '::','\\/','g') . '.pm'
endfunction

" awk script finds all subs for given path
function! PerlSubsFor (path)
    " let awk_script = '/\/\^sub / && /' . a:path . '/ { print $1 }' 
    let awk_script = '/s$/ && /' . a:path . '/ { print $1 }' 
    return split(system( "awk '" . awk_script . "' " . CtagsForShellCmd() ), '\n')
endfunction

" for a given module name, add all known subs 
function! PerlUseSubs(module)
    echo "PerlUseSubs ". a:module
    for s in PerlSubsFor(PerlModuleToRPath(a:module))
	let g:perl_use_sub[s] = 1
    endfor
endfunction

" refresh the list of available subs
function! PerlRefreshSubs()
    " store current state 
    let pos  = getpos('.')
    let save = @/
    " search and 
    silent %s/\v%(use|require)\s+(\k+)/\=PerlUsedModules()/
    let @/   = save
    call setpos('.',pos)
endfunction

" try to guess the used modules
function! PerlUsedModules ()
    " TODO:  reset list of subs to blank ... but not while loading modules :)
    " let g:perl_use_sub = {}

    " remove if mo
    let use_pragma  = "v:val =~ '^". submatch(1) . "$'"
    if ! len( filter( ['utf8','5','warnings','strict'], use_pragma ) )
	call PerlUseSubs(submatch(1))
    endif
    return submatch(0)
endfunction

let g:perl_use_module = PerlListModules()
