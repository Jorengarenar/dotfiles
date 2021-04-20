" vim: fen fdl=1

" FOLDING {{{1
" Multi line constructor {{{2

syntax match cppMultilineConstructor transparent fold '\v^\s*\S+\s*\(.*\)\s*:%(\_s*\S.*,)*\n%(\s*\S.*,)*\_s*\S.*\_s*%(\{\s*\}|\ze^\s*\{)'

" Class access specifiers {{{2

exec "syntax match cppAccessFoldDef transparent fold '"
      \ .   '\C\v'
      \ .   '%(<%(class|struct)>\_.{-}\{\n)@<='
      \ .   '\n\_s*\S\_.{-}\ze'
      \ .   '\s*<%(public|private|protected)>'
      \ . "'"

syntax region cppAccessFold transparent fold
      \ start = "\v(<%(public|private|protected)>)@<=\s*:"
      \ skip  = "\v\_s*((//.*)|(/\*\_.*\*/\s*)|(.*\".*\".*;))$"
      \ end   = "\v\n*\ze.*<%(public|private|protected)>\s*:"
      \ end   = "\v\n+\ze.*(\{.*)@<!\}"

" Boost test suite {{{2

syntax region boostTestSuite start="\v<BOOST_\w+_TEST_SUITE>" end="BOOST_AUTO_TEST_SUITE_END" transparent fold
