for h in range(1,6)
  exec "syn region markdownH" . h . "_fold transparent fold"
        \ 'start = "\v^\s*\#{' . h . '}\#@!"'
        \ 'end   = "\v\n*\ze\n?\s*\#{1,' . h . '}\#@!"'
endfor | unlet h

syn region markdownNested_fold start="```" end="```" keepend transparent fold

syn region markdownFrontMatter start='\%1l---' end='\%>1l---' transparent contains=NONE

syn clear markdownError " I want to be albe to have cursive in the middle of the word
