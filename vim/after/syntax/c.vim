if &ft !~# '\v<(c|cpp)>' | finish | endif " vim: fdl=1

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

" Fix false positive curly error {{{2
if exists("c_curly_error") && &ft == "c"
  syn clear cBlock
  syn region cBlock_ start="{" end="}" transparent fold contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cErrInBracket,@cStringGroup,@Spell
endif
" FOLDING {{{1
" Parenthesis {{{2
call utils#appendToSynRule("cParen", "region", "fold")

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
