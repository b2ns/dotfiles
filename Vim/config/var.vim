"======================================================================
"
" 全局变量和运行环境测试
"
"======================================================================


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
" 全局变量
"----------------------------------------------------------------------
let g:var_shiftwidth=2
let g:var_colorscheme="solarized8_flat"
let g:var_colorscheme_light="solarized8_high"
let g:var_background="light"
let g:var_enable_background_change_on_sunset=0
let g:var_formatter_java="java -jar ~/Downloads/google-java-format-1.15.0-all-deps.jar - "
" 日出日落时间24制(800==08:00, 1830==18:30)
let g:var_sunrise_time=830
let g:var_sunset_time=1830

if g:var_is_linux
  let g:var_slimv_swank_cmd='! gnome-terminal -e "sbcl --load /home/ding/.vim/plugged/slimv/slime/start-swank.lisp &"'
  let g:var_guifont="InconsolataLGC\ Nerd\ Font\ Mono\ 16"

elseif g:var_is_mac
  let g:var_slimv_swank_cmd='!osascript -e "tell application \"Terminal\" to do script \"sbcl --load ~/.vim/plugged/slimv/slime/start-swank.lisp\""'
  let g:var_guifont="InconsolataLGC\ Nerd\ Font\ Mono:h18"

elseif g:var_is_win
  let g:var_slimv_swank_cmd='! gnome-terminal -e "sbcl --load /home/ding/.vim/plugged/slimv/slime/start-swank.lisp &"'
  let g:var_guifont="InconsolataLGC\ Nerd\ Font\ Mono:h16"
endif
