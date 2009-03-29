runtime! ftdetect/*.vim

au BufNewFile,BufRead *.tt2
      \ if ( getline(1) . getline(2) . getline(3) =~ '<\chtml'
      \           && getline(1) . getline(2) . getline(3) !~ '<[%?]' )
      \   || getline(1) =~ '<!DOCTYPE HTML' |
      \   setf tt2html |
      \ else |
      \   setf tt2 |
      \ endif

"define START_TAG, END_TAG
    "TT2 and HTML"
    ":let b:tt2_syn_tags = '\[% %] <!-- -->'
