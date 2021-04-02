" Based on: https://vim.fandom.com/wiki/Better_indent_support_for_php_with_html

" Better indent support for PHP by making it possible to indent HTML sections as well
if exists("b:did_indent") | finish | endif

if exists("s:doing_indent_inits") | finish | endif
let s:doing_indent_inits = 1
runtime! indent/html.vim
unlet b:did_indent
runtime! indent/php.vim
unlet s:doing_indent_inits

function! GetPhpHtmlIndent(lnum)
  let [ sw_old, &l:shiftwidth ] = [ &l:shiftwidth, g:php_html_shitwidth ]
  if exists('*HtmlIndent')
    let html_ind = HtmlIndent()
  else
    let html_ind = HtmlIndentGet(a:lnum)
  endif
  let &l:shiftwidth = sw_old
  let php_ind = GetPhpIndent()
  " priority one for php indent script
  if php_ind > -1
    return php_ind
  endif
  if html_ind > -1
    if getline(a:lnum) =~ "^<?" && (0< searchpair('<?', '', '?>', 'nWb')
          \ || 0 < searchpair('<?', '', '?>', 'nW'))
      return -1
    endif
    return html_ind
  endif
  return -1
endfunction

setlocal indentexpr=GetPhpHtmlIndent(v:lnum)
setlocal indentkeys+=<>>
