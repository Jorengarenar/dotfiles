let g:tex_fold_enabled = 1
setlocal foldmethod=syntax
setlocal tabstop=3
setlocal textwidth=90
setlocal spell

let g:tex_fold_envs = ""
      \ ." algorithm"
      \ ." align"
      \ ." enumerate"
      \ ." equation"
      \ ." figure"
      \ ." gather"
      \ ." itemize"
      \ ." minipage"
      \ ." multicols"
      \ ." table"
      \ ." tabular"
      \ ." tcolorbox"
      \ ." tikzpicture"
      \ ." verbatim"

function! s:Foo() abort
  let x = filter(getqflist(), 'v:val.valid')[getqflist(#{idx: 0}).idx-1]
  wincmd k
  call setpos('.', [ 0, x.lnum, x.col, 0 ])
endfunction

augroup FilterLatexQuickfix
  autocmd!
  autocmd QuickfixCmdPost <buffer> call setqflist(filter(getqflist(), 'v:val.valid'))
  autocmd FileType qf nnoremap <silent> <CR> <CR>:call <SID>Foo()<CR>
augroup END
