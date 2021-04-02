setlocal cinoptions=g0,N-s,t0,(0,u0,U0,j1,ws,Ws,m1,J1,#0
setlocal complete-=i " Scanning included files when ^n is troublesome
setlocal foldmethod=syntax
setlocal path+=/usr/include/**

let c_curly_error  = 1
let c_space_errors = 1

let b:fold_kr = 1
