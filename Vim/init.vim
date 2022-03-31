"======================================================================
"
" initialize config
"
" forked from https://github.com/skywind3000/vim-init
"
"======================================================================

" 防止重复加载
if get(s:, 'loaded', 0) != 0
  finish
else
  let s:loaded = 1
endif

" 取得本文件所在的目录
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" 定义一个命令用来加载文件
command! -nargs=1 LoadScript exec 'so '.s:home.'/'.'<args>'

" 将 vim-init 目录加入 runtimepath
exec 'set rtp+='.s:home

" 将 ~/.vim 目录加入 runtimepath (有时候 vim 不会自动帮你加入）
set rtp+=~/.vim

"----------------------------------------------------------------------
" 模块加载
"----------------------------------------------------------------------

" 自定义的一些功能函数
LoadScript config/utils.vim

" 全局变量
LoadScript config/var.vim

" 基础配置
LoadScript config/basic.vim

" 扩展配置
LoadScript config/config.vim

" 插件加载
LoadScript config/plugins.vim

" 界面样式
LoadScript config/style.vim

" 自定义按键
LoadScript config/keymaps.vim

highlight link javaIdentifier NONE
highlight link javaDelimiter NONE
