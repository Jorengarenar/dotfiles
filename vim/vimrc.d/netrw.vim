let g:netrw_banner        = 0         " do not display info on the top of window
let g:netrw_liststyle     = 3         " tree-view
let g:netrw_sort_sequence = '[\/]$,*' " sort is affecting only: directories on the top, files below
let g:netrw_browse_split  = 4         " use the previous window to open file
let g:netrw_dirhistmax    = 0         " disable history
let g:netrw_winsize       = -28       " window size

let g:netrw_browsex_viewer = "xdg-open"

function! OpenURLUnderCursor()
	let uri = expand('<cWORD>')
	let uri = matchstr(uri, "[a-z]*:\/\/[^ >,;)'\"]*")
	let uri = substitute(uri, '#', '\\#', '')
	if uri != ''
    call job_start(g:netrw_browsex_viewer." ".uri)
	endif
endfunction
"nnoremap <silent> gx :call OpenURLUnderCursor()<CR>

augroup netrw_autocmd
  autocmd!
  autocmd filetype netrw silent! unmap <buffer> <F1>
  autocmd filetype netrw silent! unmap <buffer> <C-l>
  autocmd filetype netrw setlocal statusline=%f

  autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" | q | endif
augroup END

function! ToggleVExplorer()
  if !exists("t:explorer_buf_num")
    Vexplore $PWD
    let t:opened = 1
    let t:explorer_buf_num = bufnr("%")
    return
  endif

  if t:opened
    let explorer_win_num = bufwinnr(t:explorer_buf_num)
    let cur_win_num = winnr()

    if explorer_win_num != -1
      while explorer_win_num != cur_win_num
        exec "wincmd w"
        let cur_win_num = winnr()
      endwhile

      close
    endif

    let t:opened = 0
  else
    execute "leftabove " . abs(g:netrw_winsize) . "vsplit #" . t:explorer_buf_num
    let t:opened = 1
  endif
endfunction

command ToggleVExplorer call ToggleVExplorer()
nnoremap <silent> <C-e> :call ToggleVExplorer()<CR>
