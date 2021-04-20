setlocal fdm=marker
setlocal commentstring=!%s

autocmd BufWinEnter <buffer> exec "syn match Comment '".substitute(&l:cms, "%s", ".*", "")."'"
