function! DetectUpstart()
   let likely=0
   for i in getline(1, 1000)
      if i =~ '\v^(start|stop) on'
         setfiletype upstart
         break
      elseif i =~ '\v^(respawn limit|(end|(pre|post)-start) script)'
         let likely += 2
      elseif i =~ '\v^(set(uid|gid)|env|description|author|respawn)'
         let likely += 1
      endif

      if likely > 4
         setfiletype upstart
         break
      endif

   endfor
endfunction

augroup filetypedetect
  au BufRead,BufNewFile * call DetectUpstart()
augroup END
