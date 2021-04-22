let g:sql_type_default = 'mysql'

function! s:upper(k)
  if synIDattr(synIDtrans(synID(line('.'), col('.')-1, 0)), "name") !~# 'Comment\|String'
    return toupper(a:k)
  else
    return a:k " was comment or string, so don't change case
  endif
endfunction

function! s:create_abbreviations()
  for k in syntaxcomplete#OmniSyntaxList()
    exec "iabbrev <expr> <buffer> " . k . " <SID>upper('" . k . "')"
  endfor
endfunction
autocmd Syntax <buffer> call <SID>create_abbreviations()
