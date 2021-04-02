" Name:    Darkness
" License: The MIT License (MIT)
" Author:  Jorengarenar <dev@joren.ga>

" SETUP -----------------------------------------------------------------------

set background=dark
hi clear
if exists('syntax on') | syntax reset | endif
let g:colors_name='darkness'

" HIGHLIGHTS ------------------------------------------------------------------

hi! ColorColumn   cterm=NONE            ctermfg=NONE  ctermbg=233
hi! Comment       cterm=NONE            ctermfg=240   ctermbg=NONE
hi! CursorColumn  cterm=NONE            ctermfg=NONE  ctermbg=234
hi! CursorLine    cterm=NONE            ctermfg=NONE  ctermbg=234
hi! CursorLineNr  cterm=NONE            ctermfg=15    ctermbg=NONE
hi! DiffAdd       cterm=NONE            ctermfg=2     ctermbg=NONE
hi! DiffChange    cterm=NONE            ctermfg=15    ctermbg=NONE
hi! DiffDelete    cterm=NONE            ctermfg=9     ctermbg=NONE
hi! DiffText      cterm=NONE            ctermfg=6     ctermbg=NONE
hi! FoldColumn    cterm=NONE            ctermfg=240   ctermbg=NONE
hi! Folded        cterm=italic          ctermfg=245   ctermbg=NONE
hi! IncSearch     cterm=NONE            ctermfg=240   ctermbg=11
hi! LineNr        cterm=NONE            ctermfg=240   ctermbg=NONE
hi! MatchParen    cterm=NONE            ctermfg=249   ctermbg=240
hi! MoreMsg       cterm=bold            ctermfg=240   ctermbg=NONE
hi! NonText       cterm=NONE            ctermfg=240   ctermbg=NONE
hi! Normal        cterm=NONE            ctermfg=249   ctermbg=16
hi! Pmenu         cterm=NONE            ctermfg=249   ctermbg=240
hi! PmenuSel      cterm=NONE            ctermfg=249   ctermbg=236
hi! Question      cterm=NONE            ctermfg=9     ctermbg=NONE
hi! QuickFixLine  cterm=underline       ctermfg=NONE  ctermbg=NONE
hi! Search        cterm=NONE            ctermfg=249   ctermbg=240
hi! SignColumn    cterm=NONE            ctermfg=NONE  ctermbg=16
hi! StatusLine    cterm=NONE            ctermfg=245   ctermbg=233
hi! StatusLineNC  cterm=NONE            ctermfg=240   ctermbg=234
hi! TabLine       cterm=NONE            ctermfg=240   ctermbg=234
hi! TabLineFill   cterm=NONE            ctermfg=249   ctermbg=234
hi! TabLineSel    cterm=NONE            ctermfg=249   ctermbg=233
hi! Title         cterm=bold            ctermfg=NONE  ctermbg=NONE
hi! Todo          cterm=bold,underline  ctermfg=15    ctermbg=NONE
hi! Underlined    cterm=underline       ctermfg=249   ctermbg=NONE
hi! VertSplit     cterm=NONE            ctermfg=234   ctermbg=234
hi! Visual        cterm=NONE            ctermfg=NONE  ctermbg=236
hi! WarningMsg    cterm=NONE            ctermfg=16    ctermbg=11
hi! WildMenu      cterm=NONE            ctermfg=249   ctermbg=236

hi! link Constant   Normal
hi! link Identifier Normal
hi! link Statement  Normal
hi! link PreProc    Normal
hi! link Type       Normal
hi! link Special    Normal
hi! link ModeMsg    MoreMsg
