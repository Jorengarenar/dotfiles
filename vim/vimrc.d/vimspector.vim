" Init {{{1

let g:vimspector_base_dir         = $XDG_DATA_HOME . '/vim/vimspector'
let g:vimspector_install_gadgets  = [ 'debugpy', 'vscode-cpptools' ]

function! s:init() abort
  if !exists('g:loaded_vimpector') | return | endif

  command! -nargs=1 -complete=file Vimspector call vimspector#LaunchWithSettings(#{PROG: <q-args>})

  nnoremap <expr> <F6> exists("g:vimspector_session_windows") ? ":VimspectorReset\<CR>" :
        \ ":Vimspector " . expand('%:p:r') . "\<CR>"

  let confs = g:vimspector_base_dir . "/configurations"
  if !isdirectory(confs)
    call system("ln -s " . $XDG_CONFIG_HOME."/vim/vimspector" . " " . confs)
  endif
endfunction

augroup VIMSPECTOR_
  autocmd!
  autocmd VimEnter * call s:init()
  autocmd User VimspectorDebugEnded
        \  call system("mv ~/.vimspector.log " . $XDG_CACHE_HOME."/vim/")
        \| call delete($HOME."/.mono", "rf")
        \| let &mouse = s:mouse_old
augroup END

" UI {{{1

function! s:CustomiseUI() abort
  let [ s:mouse_old, &mouse ] = [ &mouse, "n" ]

  for w in keys(g:vimspector_session_windows)
    call win_gotoid(g:vimspector_session_windows[w])
    setlocal laststatus=2
    setlocal statusline=\ %f
    setlocal nofoldenable
  endfor

  call win_gotoid(g:vimspector_session_windows.code)
  setlocal statusline=\ %f\ %=<0x%02B>\ \ %l/%L\ :\ %c
endfunction

function! s:SetUpTerminal() abort
  if !has_key(g:vimspector_session_windows, 'terminal') | return | endif
  call win_gotoid(g:vimspector_session_windows.terminal)
endfunction

function! s:CustomiseWinBar() abort
  call win_gotoid(g:vimspector_session_windows.code)
  nunmenu WinBar
  nnoremenu WinBar.Kill  :call vimspector#Stop()<CR>
  nnoremenu WinBar.Cont  :call vimspector#Continue()<CR>
  nnoremenu WinBar.Pause :call vimspector#Pause()<CR>
  nnoremenu WinBar.Next  :call vimspector#StepOver()<CR>
  nnoremenu WinBar.Step  :call vimspector#StepInto()<CR>
  nnoremenu WinBar.Fin   :call vimspector#StepOut()<CR>
  nnoremenu WinBar.↺     :call vimspector#Restart()<CR>
  nnoremenu WinBar.X     :call <SID>VimspectorClose()<CR>
endfunction

augroup VimspectorUICustomisation
  autocmd!
  autocmd User VimspectorUICreated      call s:CustomiseUI()
  autocmd User VimspectorTerminalOpened call s:SetUpTerminal()
  autocmd User VimspectorUICreated      call s:CustomiseWinBar()
augroup END

" Mappings {{{1

" let g:vimspector_mappings = {
"       \   'stack_trace': {},
"       \   'variables': {
"       \     'set_value': [ 'c' ],
"       \   }
"       \ }

" Custom mappings while debugging ---------------------------------------------

function! s:Eval(...) abort
    call win_gotoid(g:vimspector_session_windows.output)
    startinsert
    call feedkeys(get(a:, 1, ""), "n")
endfunction

let s:mapped = {}

let s:mappings = [
      \   [ "n", "dB", "<Plug>VimspectorAddFunctionBreakpoint" ],
      \   [ "n", "db", "<Plug>VimspectorToggleBreakpoint"      ],
      \   [ "n", "dc", "<Plug>VimspectorContinue"              ],
      \   [ "n", "df", "<Plug>VimspectorStepOut"               ],
      \   [ "n", "di", "<Plug>VimspectorBalloonEval"           ],
      \   [ "n", "dj", "<Plug>VimspectorDownFrame"             ],
      \   [ "n", "dk", "<Plug>VimspectorUpFrame"               ],
      \   [ "n", "dm", "<Plug>VimspectorRunToCursor"           ],
      \   [ "n", "dn", "<Plug>VimspectorStepOver"              ],
      \   [ "n", "dp", "<Plug>VimspectorPause"                 ],
      \   [ "n", "dq", "<Plug>VimspectorStop"                  ],
      \   [ "n", "dR", "<Plug>VimspectorRestart"               ],
      \   [ "n", "ds", "<Plug>VimspectorStepInto"              ],
      \   [ "x", "di", "<Plug>VimspectorBalloonEval"           ],
      \   [ "nnore", "de", ":call <SID>Eval()<CR>"             ],
      \   [ "nnore", "dx", ":call <SID>Eval('-exec ')<CR>"     ],
      \ ]

function! s:OnJumpToFrame() abort
  if has_key(s:mapped, string(bufnr())) | return | endif

  for m in s:mappings
    exec m[0]."map <silent> <buffer> ".m[1]." ".m[2]
  endfor

  let s:mapped[string(bufnr())] = { 'modifiable': &modifiable }

  setlocal nomodifiable

endfunction

function! s:OnDebugEnd() abort
  let original_buf = bufnr()
  let hidden = &hidden

  try
    set hidden
    for bufnr in keys(s:mapped)
      try
        execute 'noautocmd buffer' bufnr

        for m in s:mappings
          exec "silent! ".m[0]."unmap <buffer> ".m[1]
        endfor

        let &l:modifiable = s:mapped[bufnr]['modifiable']
      endtry
    endfor
  finally
    execute 'noautocmd buffer' original_buf
    let &hidden = hidden
  endtry

  let s:mapped = {}
endfunction

augroup VimspectorCustomMappings
  au!
  autocmd User VimspectorJumpedToFrame call s:OnJumpToFrame()
  autocmd User VimspectorDebugEnded    call s:OnDebugEnd()
augroup END
