" sB&R - Simple Build&Run

if !exists("$TMPDIR")  | let $TMPDIR = "/tmp" | endif
if !exists("$BROWSER") | let $BROWSER = "xdg-open" | endif

let g:sBnR_compilers = {
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

let g:sBnR_makeprgs = {
      \ "ada"      : [ 0, "gnatmake % && gnatclean -c %" ],
      \ "asm"      : [ 0, "as -o %:t:r.o % && ld -s -o %:t:r %:t:r.o && rm %:t:r.o" ],
      \ "basic"    : [ 1, "vintbas %" ],
      \ "c"        : [ 0, "gcc -std=gnu99 -Wall -g % -o %:t:r" ],
      \ "cpp"      : [ 0, "g++ -std=gnu++14 -g % -o %:t:r" ],
      \ "cobol"    : [ 0, "cobc -dOFx -o %:t:r %" ],
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
      \ "tex"      : [ 0, "latexmk -outdir=%:t:r.out.d -pdfxe -interaction=nonstopmode % 1>&2" ],
      \ "xhtml"    : [ 0, "tidy -asxhtml -quiet -errors --gnu-emacs yes %" ],
      \}

let g:sBnR_runCmds = {
      \ "html"     : [ 1, "$BROWSER %:p" ],
      \ "java"     : [ 0, "java -jar %:t:r.jar" ],
      \ "markdown" : [ 0, "grip --quiet -b %" ],
      \ "plaintex" : [ 2, "zathura %:t:r.out.d/%:t:r.pdf" ],
      \ "tex"      : [ 2, "zathura %:t:r.out.d/%:t:r.pdf" ],
      \ "xhtml"    : [ 1, "$BROWSER %:p" ],
      \}

command! -nargs=* -bar RunProg      call sBnR#run(expand('%:t:r'), "<args>")
command! -nargs=* -bar Build        call sBnR#build("<args>")
command! -nargs=* -bar BuildAndRun  call sBnR#buildAndRun()

nnoremap <F7>  :Build<CR>
nnoremap <F8>  :RunProg<CR>
nnoremap <F9>  :BuildAndRun<CR>
nnoremap <F10> :w <bar> make<CR>

for [ft, comp] in items(g:sBnR_compilers)
  execute "autocmd filetype ".ft." compiler! ".comp
endfor
