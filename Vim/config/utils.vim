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
" ctrl, shift + fx 不能在终端中起作用
" map <C-Fx> is equal to map <Fy> where y = x + 24.
" map <S-Fx> is equal to map <Fy> where y = x + 12.
" So if you want to map <C-F12> to something, you can also map <F36> to the same thing.
function g:UTILBindkey(mapArgs, key, action) abort
  let key=a:key
  if !has('gui_running')
    if has('nvim')
      let key=substitute(key, '\v\c<([cs])-f(\d+)>', {m ->'f' . (m[1] == 'c' ? m[2]+24 : m[2]+12)}, '')
    endif
  endif
  exe a:mapArgs . ' ' . key . ' ' . a:action
endfunction

" 执行异步代码，利用定时器模拟异步
function g:UTILRunAsync(funcRef) abort
  return timer_start(0, a:funcRef)
endfunction

" 因为界面重绘会清空输出内容，因此需要异步输出
" 异步echo
function g:UTILEchoAsync(str) abort
  call g:UTILRunAsync({-> execute("echo '" . a:str . "'", "")})
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
  let dir=join(slice(split(file, '\ze/'), 0, -1), '')
  if !filereadable(file)
    call g:UTILMkDir(dir)
    call system("cd .>" . file)
  endif
endfunction

function g:UTILMkDir(dirname) abort
  let dir=expand(a:dirname)
  if !isdirectory(dir)
    if exists("*mkdir")
      call mkdir(dir, "p")
    endif
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
      let dict[key]=json_decode(line)
      let key=""
    endif
  endfor

  return dict
endfunction

" 序列化字典
function g:UTILSerializeDict(dict, file = "") abort
  let list=[]
  for [key, value] in items(a:dict)
    let list += [key, json_encode(value)]
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
let g:var_vim_local_storage_file="~/.cache/vim/.local_storage"
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
  let hasKey=has_key(s:var_vim_local_storage_obj, a:key)

  if a:action == "get"
    if hasKey
      return s:var_vim_local_storage_obj[a:key]
    else
      return ''
    endif
  elseif a:action == "set"
    if hasKey && s:var_vim_local_storage_obj[a:key] == a:value
      return ''
    else
      let s:var_vim_local_storage_obj[a:key]=a:value
    endif
  elseif a:action == "remove"
    if hasKey
      call remove(s:var_vim_local_storage_obj, a:key)
    else
      return ''
    endif
  elseif a:action == "clear"
    let s:var_vim_local_storage_obj={}
  endif

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
    call g:UTILLocalStorageSet('colorschemeModes', s:colorschemeModeDict)
  endif
  return s:colorschemeModeDict[a:colorscheme]
endfunction

" 设置主题
" 此时只能拿到系统内置主题
let s:defaultColorschemeList=g:UTILGetColorschemeList()
let s:defaultColorschemeDict=g:UTILList2Dict(s:defaultColorschemeList)

let s:colorschemeList=[]
let s:colorschemePos=0
" 避免无限递归的标志
let s:autoSkipColorschemeCount=0
let s:switchColorschemeDirction='next'

function g:UTILSetColorscheme(colorscheme)
  let colorscheme=a:colorscheme
  if empty(colorscheme)
    return ""
  endif

  let colorschemeModes=g:UTILGetColorschemeMode(colorscheme)
  " 因为系统初始化时背景始终是light，可能与主题不匹配导致第一次设置主题不执行
  if has_key(colorschemeModes, &background) || empty(s:colorschemeList)
    let s:autoSkipColorschemeCount = 0
    exec "colorscheme ". colorscheme
  else
    " echo a:colorscheme . ' has no ' . &background . ' mode!'
    if s:autoSkipColorschemeCount <= len(s:colorschemeList)
      let s:autoSkipColorschemeCount += 1
      let colorscheme=g:UTILSwithColorscheme(s:switchColorschemeDirction)
    else
      echo 'no colorscheme suppoert ' . &background . ' mode!'
    endif
  endif

  " 初始化主题状态
  if empty(s:colorschemeList)
    " 此时三方主题应该都已加载
    let allColorschemeList=g:UTILGetColorschemeList()
    " 过滤掉系统内置的主题
    let s:colorschemeList=filter(allColorschemeList, {idx, val -> !has_key(s:defaultColorschemeDict, val)})
    let currentColorscheme=g:UTILGetColorscheme()
    " 找到当前主题在List中的位置
    let s:colorschemePos=index(s:colorschemeList, currentColorscheme)
    if s:colorschemePos < 0
      let s:colorschemePos=0
    endif
  endif

  return colorscheme
endfunction

" 切换主题
function g:UTILSwithColorscheme(nextOrPre)
  let s:switchColorschemeDirction=a:nextOrPre
  if a:nextOrPre == 'pre'
    if s:colorschemePos > 0
      let s:colorschemePos -= 1
    else
      let s:colorschemePos = len(s:colorschemeList) - 1
    endif
  else
    if s:colorschemePos < len(s:colorschemeList) - 1
      let s:colorschemePos += 1
    else
      let s:colorschemePos = 0
    endif
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
