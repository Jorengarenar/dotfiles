let g:lsc_enable_autocomplete  = v:false

let g:lsc_auto_map = { "defaults": v:true,
      \ "Completion": "omnifunc",
      \ "ShowHover": "gK",
      \ 'NextReference': '<Leader><C-n>',
      \ 'PreviousReference': '<Leader><C-p>',
      \ }

hi! link lscDiagnosticWarning  WarningMsg

" Servers {{{1

let s:svrs = {}

if executable("ccls")
  let s:ccls = {
        \   "command": "ccls",
        \   "message_hooks": {
        \     "initialize": {
        \       "initializationOptions": {"cache": {"directory": "/tmp/ccls/cache"}},
        \       "clang": {'extraArgs': ['--gcc-toolchain=/usr'] },
        \       "rootUri": {m, p -> lsc#uri#documentUri(fnamemodify(findfile("compile_commands.json", expand("%:p") . ";"), ":p:h"))}
        \     },
        \   },
        \ }

  let s:svrs["c"]   = s:ccls
  let s:svrs["cpp"] = s:ccls
endif

if executable("jdtls")
  let s:svrs["java"] = "jdtls"
endif

if executable("pyls")
  let s:svrs["python"] = "pyls"
endif

if executable("sqls")
  let s:sqls = {
        \   "command": "sqls",
        \   "workspace_config": {
        \     "sqls": {
        \       "connections": [
        \         {
        \           "driver": 'sqlite3',
        \           "dataSourceName": expand($SQLS_SQLITE_DB),
        \         },
        \         {
        \           "driver": "mysql",
        \           "proto":  "unix",
        \           "user":   expand($SQLS_MYSQL_USER),
        \           "passwd": expand($SQLS_MYSQL_PASSWD),
        \           "path":   "/run/mysqld/mysqld.sock",
        \           "dbName": expand($SQLS_MYSQL_DB),
        \         },
        \       ],
        \     },
        \   },
        \ }

  let s:svrs["sql"] = s:sqls
endif

if executable("texlab")
  let s:svrs["tex"] = "texlab"
endif


call map(s:svrs, {_,val -> type(val) == v:t_string ? { "command": val } : val})
call map(s:svrs, {_,val -> extend(val, {"suppress_stderr": v:true})})

let g:lsc_server_commands = s:svrs

" Other {{{1

function! s:init() abort
  if !get(g:, "loaded_lsc", 0) | return | endif

  nnoremap <buffer> <F2> :LSClientAllDiagnostics<CR>

  autocmd VimEnter <buffer>
        \  if empty(filter(getqflist(), 'v:val.valid'))
        \|   exec "LSClientAllDiagnostics" | q
        \| endif

  autocmd VimLeavePre <buffer> call lsc#server#disable() | delfunction lsc#server#exit

endfunction

augroup LSC_
  autocmd!
  exec "autocmd FileType " . join(keys(s:svrs), ",") . " call s:init()"
augroup END
