let g:html_indent_autotags = "html"
let g:html_indent_style1   = "inc"

setlocal foldmethod=syntax
setlocal tabstop=2
setlocal comments+=s1:/*,mb:*,ex:*/,://

let g:php_html_shitwidth = &l:sw ? &l:sw : &l:ts
