"======================================================================
"
" 全局变量和运行环境测试
"
"======================================================================

"----------------------------------------------------------------------
" 全局变量
"----------------------------------------------------------------------
let g:var_shiftwidth=2
let g:var_colorscheme=g:UTILLocalStorageGet("colorscheme", "dracula")
let g:var_background=g:UTILLocalStorageGet("background", "dark")
let g:var_enable_background_change_on_sunset=0
" 日出日落时间24制(800==08:00, 1830==18:30)
let g:var_sunrise_time=830
let g:var_sunset_time=1830

" 不同环境某些配置不一样
if g:var_is_linux
  let g:var_guifont="InconsolataLGC\ Nerd\ Font\ Mono\ 16"

elseif g:var_is_mac
  let g:var_guifont="InconsolataLGC\ Nerd\ Font\ Mono:h16"

elseif g:var_is_win
  let g:var_guifont="InconsolataLGC\ Nerd\ Font\ Mono:h16"
endif
