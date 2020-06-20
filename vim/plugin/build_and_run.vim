let s:compilers = {
      \ "ada"      : "gnat",
      \ "c,cpp"    : "gcc",
      \ "go"       : "go",
      \ "haskell"  : "ghc",
      \ "html"     : "tidy",
      \ "java"     : "javac",
      \ "perl"     : "perl",
      \ "php"      : "php",
      \ "plaintex" : "tex",
      \ "python"   : "pyunit",
      \ "rust"     : "rustc",
      \ "tex"      : "tex",
      \}

let s:makeprgs = {
      \ "ada"      : [ 0, "gnatmake % && gnatclean -c %" ],
      \ "asm"      : [ 0, "as -o %:t:r.o % && ld -s -o %:t:r %:t:r.o && rm %:t:r.o" ],
      \ "basic"    : [ 1, "vintbas %" ],
      \ "c"        : [ 0, "gcc -std=gnu99 -g % -o %:t:r" ],
      \ "cpp"      : [ 0, "g++ -std=gnu++14 -g % -o %:t:r" ],
      \ "go"       : [ 0, "go build" ],
      \ "haskell"  : [ 0, "ghc -o %:t:r %; rm %:t:r.hi %:t:r.o" ],
      \ "html"     : [ 0, "tidy -quiet -errors --gnu-emacs yes %" ],
      \ "java"     : [ 0, "javac -d $TMPDIR/java %:p && jar cvfe %:t:r.jar %:t:r -C $TMPDIR/java ." ],
      \ "lisp"     : [ 1, "clisp %" ],
      \ "lua"      : [ 1, "lua %" ],
      \ "nasm"     : [ 0, "nasm -f elf64 -g % && ld -g -o %:t:r %:t:r.o && rm %:t:r.o" ],
      \ "perl"     : [ 1, "perl %" ],
      \ "plaintex" : [ 0, "xetex -output-directory=$TMPDIR/TeX -interaction=nonstopmode % 1>&2 && mv $TMPDIR/TeX/%:t:r.pdf ./" ],
      \ "python"   : [ 1, "python %" ],
      \ "rust"     : [ 1, "rustc %" ],
      \ "sh"       : [ 1, "chmod +x %:p && %:p" ],
      \ "tex"      : [ 0, "xelatex -output-directory=$TMPDIR/TeX -interaction=nonstopmode % 1>&2 && mv $TMPDIR/TeX/%:t:r.pdf ./" ],
      \ "xhtml"    : [ 0, "tidy -asxhtml -quiet -errors --gnu-emacs yes %" ],
      \}

let s:run_cmds = {
      \ "html"     : [ 1, "$BROWSER %:p" ],
      \ "java"     : [ 0, "java -jar %:t:r.jar" ],
      \ "markdown" : [ 0, "grip --quiet -b %" ],
      \ "plaintex" : [ 2, "zathura %:p:h/%:t:r.pdf" ],
      \ "tex"      : [ 2, "zathura %:p:h/%:t:r.pdf" ],
      \ "xhtml"    : [ 1, "$BROWSER %:p" ],
      \}


for [ft, comp] in items(s:compilers)
  execute "autocmd filetype ".ft." compiler! ".comp
endfor

function! Run(file, ...) abort
  let options = ""
  let detach = 0
  if has_key(s:run_cmds, &ft)
    let cmd = s:run_cmds[&ft][1]
    if s:run_cmds[&ft][0] == 1
      let options = "++close "
    elseif s:run_cmds[&ft][0] == 2
      let detach = 1
    endif
  elseif executable("./" . a:file)
    let cmd = "./" . a:file
  elseif has_key(s:makeprgs, &ft) && s:makeprgs[&ft][0]
    let cmd = s:makeprgs[&ft][1]
  else
    echo "I don't know how to execute this file!"
    return
  endif

  let cmd .= " ".get(a:, 1, "")

  if detach
    call system(expandcmd(cmd)." &")
  elseif has('nvim')
    execute "tabe term://".cmd
    if options == "++close "
      autocmd TermClose <buffer> call feedkeys("q")
    endif
  else
    execute "tab term ++shell ".options.cmd
  endif

endfunction

function! Build(...) abort
  write

  let interpreter = 0
  if has_key(s:makeprgs, &ft)
    let l:shellpipe_old = &shellpipe
    let &l:shellpipe    = "1>&2 2>"

    let l:makeprg_old = &makeprg
    let &l:makeprg    = "(".s:makeprgs[&ft][1]." ".get(a:, 1, "").")"

    let interpreter = s:makeprgs[&ft][0]

    if interpreter
      make
    else
      silent! make | redraw!
    endif

    let &l:makeprg   = l:makeprg_old
    let &l:shellpipe = l:shellpipe_old
  else
    execute "make %:t:r"
  endif

  return !(v:shell_error || interpreter)
endfunction

function! BuildAndRun() abort
  let file = expand('%:t:r') " current file - in case of Vim jumping to other
  if Build()
    call Run(file)
  endif
endfunction

command! -nargs=* Run         call Run(expand('%:t:r'), "<args>")
command! -nargs=* Build       call Build("<args>")
command! -nargs=* BuildAndRun call BuildAndRun()

nnoremap <F7>  :call Build()<CR>
nnoremap <F8>  :Run<CR>
nnoremap <F9>  :BuildAndRun<CR>
nnoremap <F10> :w <bar> make<CR>

" vim: fen
