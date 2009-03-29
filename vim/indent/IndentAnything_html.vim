"
" Copyright 2006 Tye Zdrojewski 
"
" Licensed under the Apache License, Version 2.0 (the "License"); you may not
" use this file except in compliance with the License. You may obtain a copy of
" the License at
" 
" 	http://www.apache.org/licenses/LICENSE-2.0
" 
" Unless required by applicable law or agreed to in writing, software distributed
" under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
" CONDITIONS OF ANY KIND, either express or implied. See the License for the
" specific language governing permissions and limitations under the License.
" 
"
" Source the standard indentation file, since we only want to adjust the
" default indentation.
sou $VIMRUNTIME/indent/html.vim

" Set the default indentation to be that of the standard indent file.
let b:defaultIndentExpr = &indentexpr

" Use IndentAnything
setlocal indentexpr=IndentAnything()

" Echo info about indentations
let b:indent_anything_echo = 1

"
" Adjust the default indentation for comments.  Set the comments for html to
" look like this: 
"
"       <!--
"          - comment here
"          -->
"
setl comments=sr:<!--,m:-,e:-->
let b:blockCommentStartRE  = '<!--'
let b:blockCommentMiddleRE = '-'
let b:blockCommentEndRE    = '-->'
let b:blockCommentMiddleExtra = 3

" Specify the syntax names for html comments and strings
let b:blockCommentRE = 'htmlComment'
let b:commentRE      = b:blockCommentRE

let b:stringRE            = 'htmlString'
let b:singleQuoteStringRE = b:stringRE
let b:doubleQuoteStringRE = b:stringRE
