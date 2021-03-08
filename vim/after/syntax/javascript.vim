syn clear javaScriptFunctionFold
syn region jsCurlyBracketsFold start="{" end="}" transparent fold containedin=ALLBUT,javaScriptFunctionFold,javaScriptEmbed

syn region jsCommentFold start="/\*" end="\*/" fold extend keepend
hi li jsCommentFold javaScriptComment
