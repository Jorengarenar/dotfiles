let javaScript_fold = 1

setlocal foldmethod=syntax
setlocal tabstop=2

autocmd Syntax <buffer> setlocal foldtext=MyFoldText()

SetFormatProg "deno fmt --options-indent-width 2"
