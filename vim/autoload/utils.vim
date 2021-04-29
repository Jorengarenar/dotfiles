function! utils#markerFoldExpr(maxlvl, ...) abort
  let line = getline(v:lnum)

  let [ m1, m2 ] = split(&l:foldmarker, ",")

  if a:0 == 0
    let comm = split(&l:comments, ',')
    call map(comm, 'substitute(v:val, ".\\{-}:", "", "")')
    let comm = '\%(' . join(comm, '\|') . '\)'
  else
    let comm = a:1
  endif

  let s:st = "\\V\\s\\*" . comm . "\\.\\{-}"
  let s:op = s:st . m1
  let s:cl = s:st . m2

  if line =~? s:op
    return "a1"
  elseif line =~? s:cl
    return "s1"
  endif

  return "="
endfunction

function! utils#upper(k)
  if synIDattr(synID(line('.'), col('.')-1, 0), "name") !~# 'Comment\|String'
    return toupper(a:k)
  else
    return a:k " was comment or string, so don't change case
  endif
endfunction

function! utils#appendToSynRule(group, type, addition) abort
  let x = split(execute("syntax list " . a:group), '\n')
  let y = index(map(deepcopy(x), 'v:val =~ ".*links to .*"'), 1)
  let y = y > 0 ? y-1 : y
  let x = split(join(x[:y]))
  let x = x[index(x, 'xxx')+1:]
  execute "syntax clear ".a:group
  execute "syntax " . a:type . " " .a:group." ". a:addition . " ".join(x)
endfunction

function! utils#CountSpell() abort
  let [ pos, spell_old, ws_old, lz_old ] = [ getpos('.'), &spell, &ws, &lz ]
  let [ &spell, &ws, &lz ] = [ 1, 0, 1 ]

  let [ counter, prev_pos ] = [ 0, pos ]
  normal! gg0

  while 1
    normal! ]S
    if getpos(".") == prev_pos | break | endif
    let [ counter, prev_pos ] = [ counter+1, getpos('.') ]
  endwhile

  call setpos('.', pos)
  let [ &spell, &ws, &lz ] = [ spell_old, ws_old, lz_old ]

  return counter
endfunction

function! utils#VisSort() range abort " sorts based on visual-block selected portion of the lines
  if visualmode() != "\<C-v>"
    exec "sil! ".a:firstline.",".a:lastline."sort i"
    return
  endif
  let [ firstline, lastline ] = [ line("'<"), line("'>") ]
  let old_a  = @a
  silent normal! gv"ay
  '<,'>s/^/@@@/
  silent! keepjumps normal! '<0"aP
  silent! keepj '<,'>sort i
  execute "sil! keepj ".firstline.",".lastline.'s/^.\{-}@@@//'
  let @a = old_a
endfun
