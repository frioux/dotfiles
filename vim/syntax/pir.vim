" Vim syntax file
" Language:	Parrot IMCC
" Maintainer:	Luke Palmer <fibonaci@babylonia.flatirons.org>
" Modified: Joshua Isom
" Last Change:	Jan 6 2006

" For installation please read:
" :he filetypes
" :he syntax
"
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
"
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax clear

syn include @Pod syntax/pod.vim
syn region pirPod start="^=[a-z]" end="^=cut" keepend contains=@Pod fold

syn keyword pirType int float num string pmc
syn match   pirPMC  /\.\(Compiler\|Continuation\|Coroutine\|CSub\|NCI\|Eval\|Sub\|Scratchpad\)/
syn match   pirPMC  /\.\(BigInt\|Boolean\|Complex\|Float\|Integer\|PMC\|String\|Hash\)/
syn match   pirPMC  /\.\(Fixed\|Resizable\)\(Boolean\|Float\|Integer\|PMC\|String\)Array/
syn match   pirPMC  /\.\(IntList\|Iterator\|Key\|ManagedStruct\|UnManagedStruct\|Pointer\)/
syn match   pirPMC  /\.\(FloatVal\|Multi\|S\|String\)\?Array/
syn match   pirPMC  /\.Perl\(Array\|Env\|Hash\|Int\|Num\|Scalar\|String\|Undef\)/
syn match   pirPMC  /\.Parrot\(Class\|Interpreter\|IO\|Library\|Object\|Thread\)/
syn keyword pirPMC self

syn keyword pirOp   goto if unless global addr

syn match pirDirectiveSub    /\.\(sub\|end\s*$\)/
syn match pirDirectiveMacro  /\.\(macro\|endm\)/
syn match pirDirective  /\.\(pcc_sub\|emit\|eom\)/
syn match pirDirective  /\.\(local\|sym\|const\|lex\|global\|globalconst\)/
syn match pirDirective  /\.\(endnamespace\|namespace\)/
syn match pirDirective  /\.\(param\|arg\|return\|yield\)/
syn match pirDirective  /\.\(pragma\|HLL\|include\|loadlib\)/
syn match pirDirective  /\.\(pcc_begin\|pcc_call\|pcc_end\|invocant\|meth_call\|nci_call\)/
syn match pirDirective  /\.\(pcc_begin_return\|pcc_end_return\)/
syn match pirDirective  /\.\(pcc_begin_yield\|pcc_end_yield\)/

syn match pirDirective  /:\(main\|method\|load\|init\|anon\|multi\|immediate\|outer\|lex\|vtable|nsentry\|subid\)/
syn match pirDirective  /:\(flat\|slurpy\|optional\|opt_flag\|named\)/

" Macro invocation
syn match pirDirective  /\.\I\i*(/he=e-1


" pirWord before pirRegister
" FIXME :: in identifiers and labels
syn match pirWord           /[A-Za-z_][A-Za-z0-9_]*/
syn match pirComment        /#.*/
syn match pirLabel          /[A-Za-z0-9_]\+:/he=e-1
syn match pirRegister       /[INPS]\([12][0-9]\|3[01]\|[0-9]\)/
syn match pirDollarRegister /\$[INPS][0-9]\+/

syn match pirNumber         /[+-]\?[0-9]\+\(\.[0-9]*\([Ee][+-]\?[0-9]\+\)\?\)\?/
syn match pirNumber         /0[xX][0-9a-fA-F]\+/
syn match pirNumber         /0[oO][0-7]\+/
syn match pirNumber         /0[bB][01]\+/

syn region pirString start=/"/ skip=/\\"/ end=/"/ contains=pirStringSpecial
syn region pirString start=/<<"\z(\I\i*\)"/ end=/^\z1$/ contains=pirStringSpecial
syn region pirString start=/<<'\z(\I\i*\)'/ end=/^\z1$/
syn region pirString start=/'/ end=/'/
syn match  pirStringSpecial "\\\([abtnvfre\\"]\|\o\{1,3\}\|x{\x\{1,8\}}\|x\x\{1,2\}\|u\x\{4\}\|U\x\{8\}\|c[A-Z]\)" contained

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_pasm_syntax_inits")
  if version < 508
    let did_pasm_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink pirPod             Comment
  HiLink pirWord            Normal
  HiLink pirComment         Comment
  HiLink pirLabel           Label
  HiLink pirRegister        Identifier
  HiLink pirDollarRegister  Identifier
  HiLink pirType            Type
  HiLink pirPMC             Type
  HiLink pirString          String
  HiLink pirStringSpecial   Special
  HiLink pirNumber          Number
  HiLink pirDirective       Macro
  HiLink pirDirectiveSub    Macro
  HiLink pirDirectiveMacro  Macro
  HiLink pirOp              Conditional

  delcommand HiLink
endif

let b:current_syntax = "pir"

" Folding rules
syn region foldManual  start=/^\s*#.*{{{/ end=/^\s*#.*}}}/ contains=ALL keepend fold
syn region foldMakro   start=/\.macro/ end=/\.endm/ contains=ALLBUT,pirDirectiveMacro keepend fold
syn region foldSub     start=/\.sub/ end=/\.end/ contains=ALLBUT,pirDirectiveSub,pirDirectiveMacro keepend fold
syn region foldIf      start=/^\s*if.*goto\s*\z(\I\i*\)\s*$/ end=/^\s*\z1:\s*$/ contains=ALLBUT,pirDirectiveSub,pirDirectiveMacro keepend fold
syn region foldUnless  start=/^\s*unless.*goto\s*\z(\I\i*\)\s*$/ end=/^\s*\z1:\s*$/ contains=ALLBUT,pirDirectiveSub,pirDirectiveMacro keepend fold

" Ops -- dynamically generated from ops2vim.pl
syn keyword pirOp band bands bnot bnots bor bors shl shr lsr rot bxor
syn keyword pirOp bxors eq eq_str eq_num eq_addr ne ne_str ne_num ne_addr
syn keyword pirOp lt lt_str lt_num le le_str le_num gt gt_str gt_num ge
syn keyword pirOp ge_str ge_num if_null unless_null cmp cmp_str cmp_num
syn keyword pirOp issame isntsame istrue isfalse isnull isgt isge isle
syn keyword pirOp islt iseq isne and not or xor end noop cpu_ret
syn keyword pirOp check_events check_events__ wrapper__ prederef__
syn keyword pirOp reserved load_bytecode load_language branch branch_cs
syn keyword pirOp bsr ret local_branch local_return jsr jump enternative
syn keyword pirOp if unless invokecc invoke yield tailcall returncc
syn keyword pirOp capture_lex newclosure set_args get_results get_params
syn keyword pirOp set_returns result_info set_addr get_addr schedule
syn keyword pirOp addhandler push_eh pop_eh throw rethrow count_eh die
syn keyword pirOp exit pushmark popmark pushaction debug bounds profile
syn keyword pirOp trace gc_debug interpinfo warningson warningsoff
syn keyword pirOp errorson errorsoff runinterp getinterp sweep collect
syn keyword pirOp sweepoff sweepon collectoff collecton needs_destroy
syn keyword pirOp loadlib dlfunc dlvar compreg new_callback annotations
syn keyword pirOp debug_init debug_load debug_break debug_print backtrace
syn keyword pirOp getline getfile trap close fdopen getstdin getstdout
syn keyword pirOp getstderr setstdout setstderr open print say printerr
syn keyword pirOp read readline peek stat seek tell abs add cmod dec div
syn keyword pirOp fdiv ceil floor inc mod mul neg pow sub sqrt acos asec
syn keyword pirOp asin atan cos cosh exp ln log10 log2 sec sech sin sinh
syn keyword pirOp tan tanh gcd lcm fact callmethodcc callmethod
syn keyword pirOp tailcallmethod addmethod can does isa newclass subclass
syn keyword pirOp get_class class addparent removeparent addrole
syn keyword pirOp addattribute removeattribute getattribute setattribute
syn keyword pirOp inspect covers exsec hav vers pic_infix__
syn keyword pirOp pic_inline_sub__ pic_get_params__ pic_set_returns__
syn keyword pirOp pic_callr__ new typeof get_repr find_method defined
syn keyword pirOp exists delete elements push pop unshift shift splice
syn keyword pirOp setprop getprop delprop prophash freeze thaw add_multi
syn keyword pirOp find_multi register unregister box iter morph clone
syn keyword pirOp exchange set assign setref deref setp_ind setn_ind
syn keyword pirOp sets_ind seti_ind copy null cleari clearn clears clearp
syn keyword pirOp ord chr chopn concat repeat length bytelength pin unpin
syn keyword pirOp substr index sprintf stringinfo upcase downcase
syn keyword pirOp titlecase join split charset charsetname find_charset
syn keyword pirOp trans_charset encoding encodingname find_encoding
syn keyword pirOp trans_encoding is_cclass find_cclass find_not_cclass
syn keyword pirOp escape compose spawnw err time gmtime localtime
syn keyword pirOp decodetime decodelocaltime sysinfo sleep sizeof
syn keyword pirOp store_lex find_lex get_namespace get_hll_namespace
syn keyword pirOp get_root_namespace get_global get_hll_global
syn keyword pirOp get_root_global set_global set_hll_global
syn keyword pirOp set_root_global find_name find_sub_not_null
