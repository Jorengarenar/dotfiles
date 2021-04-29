let g:sql_type_default = 'mysql'

augroup SQL_UPPER
  autocmd Syntax <buffer>
        \  for k in syntaxcomplete#OmniSyntaxList()
        \|   exec "iabbrev <expr> <buffer> " . k . " utils#upper('" . k . "')"
        \| endfor
        \| unlet k
augroup END
