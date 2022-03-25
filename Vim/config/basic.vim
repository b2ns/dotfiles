"======================================================================
"
" 基础配置，该配置需要兼容 vim tiny 模式
"
"======================================================================

"----------------------------------------------------------------------
" 基础
"----------------------------------------------------------------------

" 禁用 vi 兼容模式
set nocompatible

" 搜索项目级别的.vimrc配置
set exrc
set secure

" 失去焦点自动保存当前文件
autocmd FocusLost * :up

" 根据打开文件修改工作目录
set autochdir

" 设置 Backspace 键模式
set bs=eol,start,indent

" 文件换行符，默认使用 unix 换行符
set ffs=unix,dos,mac

" 打开功能键超时检测（终端下功能键为一串 ESC 开头的字符串）
set ttimeout

" 功能键超时检测 50 毫秒
set ttimeoutlen=50

" 保留原始endofline
set nofixendofline

"----------------------------------------------------------------------
" 编码
"----------------------------------------------------------------------
if has('multi_byte')
  " 内部工作编码
  set encoding=utf-8

  " 文件默认编码
  set fileencoding=utf-8

  " 打开文件时自动尝试下面顺序的编码
  set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1
endif


"----------------------------------------------------------------------
" 备份
"----------------------------------------------------------------------

" 允许备份
set backup

" 保存时备份
set writebackup

" 备份文件地址，统一管理
set backupdir=~/.vim/.tmp

" 备份文件扩展名
set backupext=.bak

" 禁用交换文件
set noswapfile

" 禁用 undo文件
set noundofile

" 创建目录，并且忽略可能出现的警告
silent! call mkdir(expand('~/.vim/.tmp'), "p", 0755)


"----------------------------------------------------------------------
" 字体
"----------------------------------------------------------------------

let &guifont=g:var_guifont


"----------------------------------------------------------------------
" 语法高亮
"----------------------------------------------------------------------
if has('syntax')
  syntax enable
  syntax on
endif


"----------------------------------------------------------------------
" 缩进宽度
"----------------------------------------------------------------------

let s:sw=g:var_shiftwidth

" 设置缩进宽度
let &sw=s:sw

" 设置 TAB 宽度
let &ts=s:sw

" 展开 tab (noexpandtab)
" set noet
set expandtab

" 如果后面设置了 expandtab 那么展开 tab 为多少字符
let &softtabstop=s:sw


augroup PythonTab
  au!
  " 如果你需要 python 里用 tab，那么反注释下面这行字，否则vim会在打开py文件
  " 时自动设置成空格缩进。
  "au FileType python setlocal shiftwidth=4 tabstop=4 noexpandtab
augroup END

"----------------------------------------------------------------------
" 缩进
"----------------------------------------------------------------------
" 自动缩进
set autoindent

" 打开 C/C++ 语言缩进优化
set cindent

set smartindent

if has('autocmd')
  filetype plugin indent on
  set completeopt=longest,menu
endif


"----------------------------------------------------------------------
" 搜索
"----------------------------------------------------------------------

" 搜索时忽略大小写
set ignorecase

" 智能搜索大小写判断，默认忽略大小写，除非搜索内容包含大写字母
set smartcase

" 高亮搜索内容
set hlsearch

" 查找输入时动态增量显示查找结果
set incsearch


"----------------------------------------------------------------------
" 鼠标
"----------------------------------------------------------------------
set mouse=a
" Hide the mouse cursor while typing
set mousehide
set selection=exclusive
set selectmode=mouse,key

"----------------------------------------------------------------------
" 设置代码折叠
"----------------------------------------------------------------------
if has('folding')
  " 允许代码折叠
  set foldenable

  " 代码折叠默认使用缩进
  set fdm=indent

  " 默认打开所有缩进
  set foldlevel=99

  " 启动 vim 时关闭折叠代码
  set nofoldenable
endif


"----------------------------------------------------------------------
" 其他
"----------------------------------------------------------------------

" 延迟绘制（提升性能）
set lazyredraw

" 设置 tags：当前文件所在目录往上向根目录搜索直到碰到 .tags 文件
" 或者 Vim 当前目录包含 .tags 文件
set tags=./.tags;,.tags

" 如遇Unicode值大于255的文本，不必等到空格再折行
set formatoptions+=m

" 合并两行中文时，不在中间加空格
set formatoptions+=B

" 多行合并时没有空格
set nojoinspaces

" 去除空行的多余空格
" set linespace=0


"----------------------------------------------------------------------
" 文件搜索和补全时忽略下面扩展名
"----------------------------------------------------------------------
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class

set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib "stuff to ignore when tab completing
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz    " MacOSX/Linux
set wildignore+=*DS_Store*,*.ipch
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**
set wildignore+=*/.nx/**,*.app,*.git,.git
set wildignore+=*.wav,*.mp3,*.ogg,*.pcm
set wildignore+=*.mht,*.suo,*.sdf,*.jnlp
set wildignore+=*.chm,*.epub,*.pdf,*.mobi,*.ttf
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu
set wildignore+=*.gba,*.sfc,*.078,*.nds,*.smd,*.smc
set wildignore+=*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android
