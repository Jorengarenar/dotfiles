if &ft !~# '\v<(c|cpp)>' | finish | endif

" REGIONS {{{1
" Include guards {{{2

syntax region cIncludeGuarded transparent matchgroup=Dimmer
      \ start = "\v#ifndef \z((.+_H.*_?))\n#define \1"
      \ end   = "\v#endif\ze /[/*] \z1>"

" Extern "C" {{{2

syntax region cExternC transparent matchgroup=Dimmer
      \ start = '\v#ifdef __cplusplus\nextern "C" \{\n#endif'
      \ end   = '\v#ifdef __cplusplus\n}%(\s*//.*)?\n#endif'

" BAD STYLE {{{1
" 'case' label {{{2

syn clear cLabel
syn match cLabel "\v<%(case|default)>\ze%(\s+\S+)?\s*:" display
syntax match cCaseBadFormat "\v%(<%(case|default)>.*)@<!%(\S.*)@<=<%(case|default)>\ze%(\s+\S+)?\s*:" display
hi def link cCaseBadFormat cError

" FOLDING {{{1
" Parenthesis {{{2
call AppendToSynRule("cParen", "region", "fold")

" K&R style {{{2

if get(b:, "fold_kr", 0)
  let s:contains = ''
  if exists("c_curly_error")
    let s:contains = ' contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,@cStringGroup,@Spell'
  endif

  let s:pattern = '%('

  if &ft ==# "cpp"
    " struct/class inheriting
    let s:pattern .= ''
          \ . '%(<struct|<class)@<='
          \ . '\s\ze\s*\S+[^:]:[^:]\s*\S+.*'
    let s:pattern .= '|'

    " Constructors
    let s:pattern .= ''
          \ . '%('
          \ .    '%([^,:]|\n|^|<%(public|private|protected)>\s*:)'
          \ .    '\n\s*'
          \ . ')@<='
          \ . '%(<%(while|for|if|switch|catch)>)@!'
          \ . '\S\ze\S*%(::\S+)*\s*\(.*\)\s*%(:.*)?'
    let s:pattern .= '|'
  endif

  let s:pattern .= '%(<%(while|for|if|switch|catch)\(.*)@<=\)\ze\s*' . '|'

  let s:pattern .= ''
        \ . '%('
        \ .    '^\s*%(//.*|.*\*/|\{|<%(public|private|protected)>\s*:|.*\>)?'
        \ .    '\s*\n\s*\S+'
        \ . ')@<='
        \ . '\s\ze\s*\S+\s*'
        \ . '%(.*[^:]:[^:].*)@!'
        \ . '%(\s+\S+)*'

  let s:pattern .= ')%(;\s*)@<!%(//.*|/\*.*\*/)?\n\s*'

  syn clear cBlock
  exec 'syn region cBlock_ end="}" fold' . s:contains
        \ . ' start = "\%#=1\C\v' . s:pattern . '\{"'
        \ . ' start = "\%#=1\C\v%(' . s:pattern . ')@<!\{"'

  unlet s:contains s:pattern
endif

" Switch's cases {{{2

syntax region cCaseFold transparent fold
      \ start = "\v%(<case>\s+\S+\s*)@<=:%(\s|$)"
      \ start = "\v%(<default>\s*)@<=:"
      \ end   = "\v\n?\ze\n*\s*<%(case|default)>(\s+\S+)?\s*:"
      \ end   = "\v\n?\ze\n*%(\s*//.*\n\s*)+<%(case|default)>%(\s+\S+)?\s*:"
      \ end   = "\v\n?\ze\n+\s*/\*.*\*/\n?\s*<%(case|default)>%(\s+\S+)?\s*:"
      \ end   = "\n\ze\n*.*}"

" Multiline macro {{{2

syntax region cMacroFold start="#define .*\\$" end="\v%(\\\n)@<=.*[^\\]\_$" keepend transparent fold

" Multiline string {{{2

syntax region cStringFold transparent fold
      \ start = "\v%(%(const\s)?\s*char)@<=\s+.*\\$"
      \ end   = ";"

" Long comment {{{2

syntax region cLongComment start="^\s*//.*\n\ze\%(\s*//.*\n\)\{3,}" end="^\%(//\)\@!" fold
hi link cLongComment cCommentL

" Preprocessor '#if' folding {{{2

"syntax region cPreProcFold transparent fold
"      \ start = "\v#if%(ndef (.+_H.*_?)\n#define \1)@!"
"      \ skip  = "\v\#endif //\s*(.+_H.*_?)"
"      \ end   = "#endif"

" Doxygen groups {{{2

syntax region doxygenGroupFold matchgroup=Comment transparent fold
      \ start = '\(///.*\n\)*///.*@{.*'
      \ end   = '///.*@}.*'
