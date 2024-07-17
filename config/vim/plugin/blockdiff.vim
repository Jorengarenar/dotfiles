" blockdiff
" Author:  Jorengarenar
" License: MIT

if exists('g:loaded_blockdiff') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

let s:blocks = []

function! BlockDiff() abort
  tabnew
  let l:index = 0
  for block in s:blocks
    if l:index != 0
      vnew
    endif
    call setline(1, block)
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
    diffthis
    let l:index += 1
  endfor

endfunction

command! BlockDiffShow     call BlockDiff()
command! BlockDiffClean    let s:blocks = []
command! -range BlockDiff  let s:blocks += [ getline(<line1>, <line2>) ]

let g:loaded_blockdiff = 1
let &cpo = s:cpo_save | unlet s:cpo_save
