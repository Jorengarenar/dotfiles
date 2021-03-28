" Modified https://github.com/lighttiger2505/sqls.vim

if !executable('sqls') | finish | endif

" LSP helpers {{{1

if     get(g:, "lsp_loaded", 0)

  function! s:lsp_uri() abort
      return get(lsp#get_text_document_identifier(), 'uri', v:null)
  endfunction

  function! s:lsp_errmsg(msg) abort
    call lsp#utils#error(a:msg)
  endfunction

  function! s:lsp_exec(method, params, callback, server_name, sync) abort
      call lsp#send_request(a:server_name, {
            \   'method': a:method,
            \   'params': a:params,
            \   'sync': a:sync,
            \   'on_notification': a:callback,
            \ })
  endfunction

  function! s:lsp_is_error(o) abort
    return lsp#client#is_error(o)
  endfunction

  function! s:lsp_get_resp(data)
    return a:data['response']['result']
  endfunction

  function! s:lsp_get_recent_visual_range() abort
    return lsp#utils#range#_get_recent_visual_range()
  endfunction

elseif get(g:, "loaded_lsc", 0)

  function! s:lsp_uri() abort
      return lsc#uri#documentUri()
  endfunction

  function! s:lsp_errmsg(msg) abort
    call lsc#message#error(a:msg)
  endfunction

  function! s:lsp_exec(method, params, callback, ...) abort
    if has_key(g:lsc_server_commands, &filetype)
      call lsc#server#userCall(a:method, a:params, a:callback)
    endif
  endfunction

  function! s:lsp_is_error(...) abort
    return v:false
  endfunction

  function! s:lsp_get_resp(data)
    return a:data
  endfunction

  " recent visual range {{{
  function! s:to_char(expr, lnum, col) abort
    let l:lines = getbufline(a:expr, a:lnum)
    if l:lines == []
      if type(a:expr) != v:t_string || !filereadable(a:expr)
        " invalid a:expr
        return a:col - 1
      endif
      " a:expr is a file that is not yet loaded as a buffer
      let l:lines = readfile(a:expr, '', a:lnum)
    endif
    let l:linestr = l:lines[-1]
    return strchars(strpart(l:linestr, 0, a:col - 1))
  endfunction

  function! s:vim_to_lsp(expr, pos) abort
    return {
          \   'line': a:pos[0] - 1,
          \   'character': s:to_char(a:expr, a:pos[0], a:pos[1])
          \ }
  endfunction

  function! s:lsp_get_recent_visual_range() abort
    let l:start_pos = getpos("'<")[1 : 2]
    let l:end_pos = getpos("'>")[1 : 2]
    let l:end_pos[1] += 1 " To exclusive

    " Fix line selection.
    let l:end_line = getline(l:end_pos[0])
    if l:end_pos[1] > strlen(l:end_line)
      let l:end_pos[1] = strlen(l:end_line) + 1
    endif

    let l:range = {}
    let l:range['start'] = s:vim_to_lsp('%', l:start_pos)
    let l:range['end'] = s:vim_to_lsp('%', l:end_pos)
    return l:range
  endfunction
  " }}}

else
  finish
endif

" sqls.vim {{{1

let s:commands = {}

function! s:_execute_query(selection) abort
  let l:mode = 'n'
  if a:selection
    let l:mode = 'v'
  endif
  call s:execute_query(l:mode)
endfunction

function! s:execute_query(mode) abort
  let l:args = {
        \   'server_name': 'sqls',
        \   'command_name': 'executeQuery',
        \   'command_args': [s:lsp_uri()],
        \   'callback_func': 's:handle_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ }
  if a:mode ==# 'v'
    let l:args['command_range'] = s:lsp_get_recent_visual_range()
  endif
  call s:lsp_execute_command(args)
endfunction

function! s:_execute_query_vertical(selection) abort
  let l:mode = 'n'
  if a:selection
    let l:mode = 'v'
  endif
  call s:execute_query_vertical(l:mode)
endfunction

function! s:execute_query_vertical(mode) abort
  let l:args = {
        \   'server_name': 'sqls',
        \   'command_name': 'executeQuery',
        \   'command_args': [s:lsp_uri(), '-show-vertical'],
        \   'callback_func': 's:handle_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ }
  if a:mode ==# 'v'
    let l:args['command_range'] = s:lsp_get_recent_visual_range()
  endif
  call s:lsp_execute_command(args)
endfunction

function! s:show_databases() abort
  call s:lsp_execute_command({
        \   'server_name': 'sqls',
        \   'command_name': 'showDatabases',
        \   'command_args': v:null,
        \   'callback_func': 's:handle_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ })
endfunction

function! s:show_schemas() abort
  call s:lsp_execute_command({
        \   'server_name': 'sqls',
        \   'command_name': 'showSchemas',
        \   'command_args': v:null,
        \   'callback_func': 's:handle_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ })
endfunction

function! s:show_connections() abort
  call s:lsp_execute_command({
        \   'server_name': 'sqls',
        \   'command_name': 'showConnections',
        \   'command_args': v:null,
        \   'callback_func': 's:handle_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ })
endfunction

function! s:show_tables() abort
  echo 'no implements'
endfunction

function! s:describe_table() abort
  echo 'no implements'
endfunction

function! s:switch_database(db_name) abort
  call s:lsp_execute_command({
        \   'server_name': 'sqls',
        \   'command_name': 'switchDatabase',
        \   'command_args': [a:db_name],
        \   'callback_func': 's:handle_no_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ })
  return
endfunction

function! s:switch_connection(conn_index) abort
  call s:lsp_execute_command({
        \   'server_name': 'sqls',
        \   'command_name': 'switchConnections',
        \   'command_args': [a:conn_index],
        \   'callback_func': 's:handle_no_preview',
        \   'sync': v:false,
        \   'bufnr': bufnr('%'),
        \ })
  return
endfunction

function! s:lsp_execute_command(params) abort
  let l:command_name = a:params['command_name']
  let l:command_args = get(a:params, 'command_args', v:null)
  let l:command_range = get(a:params, 'command_range', v:null)
  let l:server_name = get(a:params, 'server_name', '')
  let l:callback_func = get(a:params, 'callback_func', 's:handle_no_preview')
  let l:bufnr = get(a:params, 'bufnr', -1)
  let l:sync = get(a:params, 'sync', v:false)

  " create command.
  let l:command = { 'command': l:command_name }
  if l:command_args isnot v:null
    let l:command['arguments'] = l:command_args
  endif
  if l:command_range isnot v:null
    let l:command['range'] = l:command_range
  endif

  " execute command on local.
  if has_key(s:commands, l:command_name)
    try
      call s:commands[l:command_name]({
            \   'bufnr': l:bufnr,
            \   'server_name': l:server_name,
            \   'command': l:command,
            \ })
    catch /.*/
      call s:lsp_errmsg(printf('Execute command failed: %s', string(a:params)))
    endtry
    return
  endif

  " execute command on server.
  if !empty(l:server_name)
    call s:lsp_exec( 'workspace/executeCommand', l:command, function(l:callback_func, [l:server_name, l:command]), l:server_name, l:sync)
  endif
  echo 'Do ' . l:command_name
endfunction


function! s:handle_no_preview(server_name, command, data) abort
  if s:lsp_is_error(a:data['response'])
    call s:lsp_errmsg('Execute command failed on ' . a:server_name . ': ' . string(a:command) . ' -> ' . string(a:data))
    return
  endif

  echo get(a:command, 'command', '') . ' Done'
endfunction

function! s:handle_preview(server_name, command, data) abort
  if s:lsp_is_error(a:data['response'])
    call s:lsp_errmsg('Execute command failed on ' . a:server_name . ': ' . string(a:command) . ' -> ' . string(a:data))
    return
  endif

  call s:open_preview_buffer(s:lsp_get_resp(a:data), 'LSP ExecuteCommand')
  echo get(a:command, 'command', '') . ' Done'
endfunction

function! s:escape_string_for_display(str) abort
  return substitute(substitute(a:str, '\r\n', '\n', 'g'), '\r', '\n', 'g')
endfunction

function! s:open_preview_buffer(data, buf_filetype) abort
  if !exists("s:preview_win_id") || !win_gotoid(s:preview_win_id)
    new
    let s:preview_win_id = win_getid()
  else
    %d_
  endif

  " set preview content
  call setline(1, split(s:escape_string_for_display(a:data), '\n'))

  " setup preview window
  setlocal
        \ bufhidden=wipe nomodified nobuflisted noswapfile nonumber
        \ nocursorline nowrap nonumber norelativenumber signcolumn=no nofoldenable
        \ nospell nolist nomodeline
  silent! let &l:filetype = a:buf_filetype

  " set the focus to the preview window
  call win_gotoid(s:preview_win_id)
endfunction

function! s:get_selection_pos(type) abort
  if a:type ==? 'v'
    let l:start_pos = getpos("'<")[1:2]
    let l:end_pos = getpos("'>")[1:2]
    " fix end_pos column (see :h getpos() and :h 'selection')
    let l:end_line = getline(l:end_pos[0])
    let l:offset = (&selection ==# 'inclusive' ? 1 : 2)
    let l:end_pos[1] = len(l:end_line[:l:end_pos[1]-l:offset])
    " edge case: single character selected with selection=exclusive
    if l:start_pos[0] == l:end_pos[0] && l:start_pos[1] > l:end_pos[1]
      let l:end_pos[1] = l:start_pos[1]
    endif
  elseif a:type ==? 'line'
    let l:start_pos = [line("'["), 1]
    let l:end_lnum = line("']")
    let l:end_pos = [line("']"), len(getline(l:end_lnum))]
  elseif a:type ==? 'char'
    let l:start_pos = getpos("'[")[1:2]
    let l:end_pos = getpos("']")[1:2]
  else
    let l:start_pos = [0, 0]
    let l:end_pos = [0, 0]
  endif

  return l:start_pos + l:end_pos
endfunction


" commands & mappings {{{1

command! -range SqlsExecuteQuery call s:_execute_query(<range> != 0)
command! -range SqlsExecuteQueryVertical call s:_execute_query_vertical(<range> != 0)
command! SqlsShowDatabases call s:show_databases()
command! SqlsShowSchemas call s:show_schemas()
command! SqlsShowConnections call s:show_connections()
command! SqlsDescribeTable call s:describe_table()
command! -nargs=1 SqlsSwitchDatabase call s:switch_database("<args>")
command! -nargs=1 SqlsSwitchConnection call s:switch_connection("<args>")
"command! SqlsShowTables call s:show_tables()

nnoremap <F8> :w <bar> <C-u>call <SID>execute_query('n')<CR>
vnoremap <F8> :w <bar> <C-u>call <SID>execute_query('v')<CR>
