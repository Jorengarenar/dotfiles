" fasterWinHopping.vim
" Maintainer:  Jorengarenar <dev@joren.ga>

if exists('g:loaded_fasterWinHopping') | finish | endif
let s:cpo_save = &cpo | set cpo&vim

function! s:CtrlW() abort " switching to windows
  let c = getchar(0)
  let c = type(c) ? c : nr2char(c)
  retu index(["\<C-h>", "\<C-j>", "\<C-k>", "\<C-l>"], c) >= 0 ? "\<C-w>".c : c
endfunction

nmap <silent> <expr> <C-w> <SID>CtrlW()
nmap <silent> <C-w><C-h> :wincmd h<CR><C-w>
nmap <silent> <C-w><C-j> :wincmd j<CR><C-w>
nmap <silent> <C-w><C-k> :wincmd k<CR><C-w>
nmap <silent> <C-w><C-l> :wincmd l<CR><C-w>

tmap <silent> <expr> <C-w> <SID>CtrlW()
tmap <silent> <C-w><C-h> <C-\><C-n>:wincmd h<CR><C-w>
tmap <silent> <C-w><C-j> <C-\><C-n>:wincmd j<CR><C-w>
tmap <silent> <C-w><C-k> <C-\><C-n>:wincmd k<CR><C-w>
tmap <silent> <C-w><C-l> <C-\><C-n>:wincmd l<CR><C-w>

let g:loaded_fasterWinHopping = 1
let &cpo = s:cpo_save | unlet s:cpo_save
