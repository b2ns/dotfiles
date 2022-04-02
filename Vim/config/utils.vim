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
" 通用方法
"----------------------------------------------------------------------
" 在List中查找元素，返回index
function g:UTILListFind(list, item) abort
  let i = 0
  for it in a:list
    if (it is a:item)
      return i
    endif
    let i += 1
  endfor
  return -1
endfunction

" List -> Dict
function g:UTILList2Dict(list) abort
  let dict={}
  for it in a:list
    let dict[it]=1
  endfor
  return dict
endfunction

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

" 反序列化字典
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

" 序列化字典
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

"----------------------------------------------------------------------
" 实现一个localStorage来持久化一些状态
"----------------------------------------------------------------------
let g:var_vim_local_storage_file="~/._vim_local_storage_"
let s:var_vim_local_storage_obj=""

function g:UTILLocalStorageSet(key, value) abort
  call s:LocalStorageAction('set', a:key, a:value)
endfunction

function g:UTILLocalStorageRemove(key) abort
  call s:LocalStorageAction('remove', a:key)
endfunction

function g:UTILLocalStorageClear() abort
  call s:LocalStorageAction('clear')
endfunction

function g:UTILLocalStorageGet(key, fallbackValue = "") abort
  let value = s:LocalStorageAction('get', a:key)
  if empty(value)
    return a:fallbackValue
  endif
  return value
endfunction

function g:UTILLocalStorageShow() abort
  echo s:var_vim_local_storage_obj
endfunction

function s:LocalStorageInit() abort
  let file=expand(g:var_vim_local_storage_file)
  if !filereadable(file)
    call g:UTILMkFile(file)
  endif
  let s:var_vim_local_storage_obj=g:UTILDeserializeDict(file)
endfunction

function s:LocalStorageAction(action, key = "", value = "") abort
  if type(s:var_vim_local_storage_obj) == type("")
    call s:LocalStorageInit()
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
" 主题配置
"----------------------------------------------------------------------
" 获取主题列表
function g:UTILGetColorschemeList()
  return sort(getcompletion('','color'))
endfunction

" 获取当前主题
function g:UTILGetColorscheme()
  return substitute(execute("colorscheme"),"\n","","")
  " return g:colors_name
endfunction

" 判断主题是否拥有light或dark模式
" 主题和背景不适配时，g:colors_name会不存在，利用此特性来判断主题是否支持light或dark
function s:TestColorschemeMode(colorscheme, mode)
  let flag=0
  " 记录之前的状态
  let preColorScheme=g:UTILGetColorscheme()

  " 无法通过let &colorscheme=的方式设置
  exec "colorscheme ". a:colorscheme
  let &background=a:mode
  if exists('g:colors_name')
    let flag=1
  endif

  " 还原之前的状态
  exec "colorscheme ". preColorScheme

  return flag
endfunction

let s:colorschemeModeDict=g:UTILLocalStorageGet('colorschemeModes', {})
function g:UTILGetColorschemeMode(colorscheme)
  if !has_key(s:colorschemeModeDict, a:colorscheme)
    let s:colorschemeModeDict[a:colorscheme]={}
    if s:TestColorschemeMode(a:colorscheme, 'dark')
      let s:colorschemeModeDict[a:colorscheme].dark=1
    endif
    if s:TestColorschemeMode(a:colorscheme, 'light')
      let s:colorschemeModeDict[a:colorscheme].light=1
    endif
  endif
  return s:colorschemeModeDict[a:colorscheme]
endfunction

" 设置主题
" 此时只能拿到系统内置主题
let s:defaultColorschemeList=g:UTILGetColorschemeList()
let s:defaultColorschemeDict={}
for item in s:defaultColorschemeList
  let s:defaultColorschemeDict[item]=1
endfor

let s:colorschemeList=[]
let s:colorschemePos=0

function g:UTILSetColorscheme(colorscheme)
  if empty(a:colorscheme)
    return ""
  endif

  exec "colorscheme ". a:colorscheme

  " 没有某个模式的主题自动切换模式
  let colorschemeModes=g:UTILGetColorschemeMode(a:colorscheme)
  if !has_key(colorschemeModes, &background)
    echo a:colorscheme . ' has no ' . &background . ' mode!'
    call g:UTILToggleBackground()
  endif

  " 初始化主题状态
  if empty(s:colorschemeList)
    " 此时三方主题应该都已加载
    let allColorschemeList=g:UTILGetColorschemeList()
    " 过滤掉系统内置的主题
    let s:colorschemeList=filter(allColorschemeList, {idx, val -> !has_key(s:defaultColorschemeDict, val)})
    let currentColorscheme=g:UTILGetColorscheme()
    " 找到当前主题在List中的位置
    let s:colorschemePos=g:UTILListFind(s:colorschemeList, currentColorscheme)
    if s:colorschemePos < 0
      let s:colorschemePos=0
    endif
  endif

  return a:colorscheme
endfunction

" 切换主题
function g:UTILPreColorscheme()
  if s:colorschemePos > 0
    let s:colorschemePos -= 1
  else
    let s:colorschemePos = len(s:colorschemeList) - 1
  endif
  return g:UTILSetColorscheme(get(s:colorschemeList, s:colorschemePos))
endfunction

function g:UTILNextColorscheme()
  if s:colorschemePos < len(s:colorschemeList) - 1
    let s:colorschemePos += 1
  else
    let s:colorschemePos = 0
  endif
  return g:UTILSetColorscheme(get(s:colorschemeList, s:colorschemePos))
endfunction

" 设置背景颜色
function g:UTILSetBackground(bg)
  if &background != a:bg
    let colorscheme=g:UTILGetColorscheme()
    let colorschemeModes=g:UTILGetColorschemeMode(colorscheme)
    if has_key(colorschemeModes, a:bg)
      let &background=a:bg
    else
      echo colorscheme . ' has no ' . a:bg . ' mode!'
      return ""
    endif
  endif
  return a:bg
endfunction

" 切换背景颜色
function g:UTILToggleBackground()
  return g:UTILSetBackground(&background == "dark" ? "light" : "dark")
endfunction

" 根据时间切换背景颜色
function g:UTILSetBackgroundOnTime(sunriseTime, sunsetTime)
  let l:time = strftime("%H%M")
  let l:bg = "light"
  if l:time <= a:sunriseTime || l:time >= a:sunsetTime
    let l:bg = "dark"
  endif
  return g:UTILSetBackground(l:bg)
endfunction
