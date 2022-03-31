"----------------------------------------------------------------------
" 运行环境
"----------------------------------------------------------------------
if !exists("g:os")
  if has("win64") || has("win32") || has("win16")
    let g:os="Windows"
  else
    let g:os=substitute(system('uname -s'), '\n', '', '')
  endif
endif

let g:var_is_linux=g:os ==? "Linux"
let g:var_is_mac=g:os ==? "Darwin"
let g:var_is_win=g:os ==? "Windows"


"----------------------------------------------------------------------
" 实现一个localStorage来持久化一些状态
"----------------------------------------------------------------------
let g:var_vim_local_storage_file="~/._vim_local_storage_"
let s:var_vim_local_storage_obj=""

function g:UTILLocalStorageSet(key, value) abort
  call LocalStorageAction('set', a:key, a:value)
endfunction

function g:UTILLocalStorageRemove(key) abort
  call LocalStorageAction('remove', a:key)
endfunction

function g:UTILLocalStorageClear() abort
  call LocalStorageAction('clear')
endfunction

function g:UTILLocalStorageGet(key, fallbackValue = "") abort
  let value = LocalStorageAction('get', a:key)
  if empty(value)
    return a:fallbackValue
  endif
  return value
endfunction

function LocalStorageInit() abort
  let file=expand(g:var_vim_local_storage_file)
  if !filereadable(file)
    call g:UTILMkFile(file)
  endif
  let s:var_vim_local_storage_obj=g:UTILDeserializeDict(file)
endfunction

function LocalStorageAction(action, key = "", value = "") abort
  if type(s:var_vim_local_storage_obj) == type("")
    call LocalStorageInit()
  endif

  try
    if a:action == "get"
      return s:var_vim_local_storage_obj[a:key]
    elseif a:action == "set"
      let s:var_vim_local_storage_obj[a:key]=a:value
    elseif a:action == "remove"
      call remove(s:var_vim_local_storage_obj, a:key)
    elseif a:action == "clear"
      let s:var_vim_local_storage_obj={}
    endif
  catch /.*/
    return ""
  endtry

  call g:UTILSerializeDict(s:var_vim_local_storage_obj, expand(g:var_vim_local_storage_file))
endfunction

"----------------------------------------------------------------------
" 通用方法
"----------------------------------------------------------------------
function g:UTILMkFile(filename) abort
  let file=expand(a:filename)
  if !filereadable(file)
    call system("cd .>" . file)
  else
    echom file . " already exists!"
  endif
endfunction

function g:UTILMkDir(dirname) abort
  let dir=expand(a:dirname)
  if !isdirectory(dir)
    if exists("*mkdir")
      call mkdir(dir, "p")
    endif
  else
    echom dir . " already exists!"
  endif
endfunction

function g:UTILDeserializeDict(fileOrList) abort
  let list=a:fileOrList
  let dict={}
  let key=""

  if type(a:fileOrList) == type("")
    let file=expand(a:fileOrList)
    if filereadable(file)
      let list=readfile(file, '')
    else
      echom file . " not exists!"
      return 0
    endif
  endif

  for line in list
    if empty(key)
      let key=line
    else
      let dict[key]=line
      let key=""
    endif
  endfor

  return dict
endfunction

function g:UTILSerializeDict(dict, file = "") abort
  let list=[]
  for item in items(a:dict)
    let list += item
  endfor
  if !empty(a:file)
    let file=expand(a:file)
    call writefile(list, file)
  endif

  return list
endfunction

