let s:formatprg_for_filetype = {
      \ "arduino"     : "uncrustify --l CPP base kr mb stroustrup 1tbs 2sw",
      \ "c"           : "uncrustify --l C base kr mb",
      \ "cmake"       : "cmake-format --command-case lower -",
      \ "cpp"         : "uncrustify --l CPP base kr mb stroustrup",
      \ "cs"          : "uncrustify --l CS base kr mb java",
      \ "css"         : "css-beautify -s 2 --space-around-combinator",
      \ "go"          : "gofmt",
      \ "html"        : "tidy -q -w -i --show-warnings 0 --show-errors 0 --tidy-mark no",
      \ "java"        : "uncrustify --l JAVA base kr mb java",
      \ "javascript"  : "js-beautify -s 2",
      \ "json"        : "js-beautify -s 2",
      \ "python"      : "autopep8 -",
      \ "sql"         : "sqlformat -k upper -r -",
      \ "xhtml"       : "tidy -asxhtml -q -m -w -i --show-warnings 0 --show-errors 0 --tidy-mark no --doctype loose",
      \ "xml"         : "tidy -xml -q -m -w -i --show-warnings 0 --show-errors 0 --tidy-mark no",
      \}

for [ft, fp] in items(s:formatprg_for_filetype)
  execute "autocmd FileType ".ft." let &l:formatprg=\"".fp."\" | setlocal formatexpr="
endfor
