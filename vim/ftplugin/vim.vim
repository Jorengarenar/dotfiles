let g:vimsyn_folding="aflmpPrt"
setlocal foldmethod=syntax
setlocal tabstop=2

" ColorDemo - preview of Vim 256 colors
function! ColorDemo() abort
  10 vnew
  setlocal nonumber buftype=nofile bufhidden=hide noswapfile statusline=\ Color\ demo
  let num = 255
  while num >= 0
    execute 'hi col_'.num.' ctermbg='.num.' ctermfg='.num
    execute 'syn match col_'.num.' "='.printf("%3d", num).'" containedIn=ALL'
    call append(0, ' '.printf("%3d", num).'  ='.printf("%3d", num))
    let num -= 1
  endwhile
endfunction
