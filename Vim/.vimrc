"""""""""""""""""""""""""""""""""""""""""""
"Description: my configration for Vim     "
"Author: b2ns                             "
"""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""  Vundle插件管理器  """""""""""""""""""""""""""
set nocompatible                   " required
filetype off                       " required

set rtp+=~/.vim/bundle/Vundle.vim  " set the runtime path to include Vundle and initialize

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'     " let Vundle manage Vundle, required

"插件安装#######################################################
Plugin 'scrooloose/nerdtree'      " 文件浏览
Plugin 'majutsushi/tagbar'        " 函数列表

Plugin 'kovisoft/slimv'           " Lisp
Plugin 'Valloric/YouCompleteMe'   " C/C++自动补全
Plugin 'marijnh/tern_for_vim'     " javascript补全引擎
Plugin 'mattn/emmet-vim'          " html、css、xml等补全
Plugin 'davidhalter/jedi-vim'     " python补全引擎
Plugin 'klen/python-mode'         " python高亮
"Plugin 'scrooloose/syntastic'    " 语法检查

"Plugin 'terryma/vim-multiple-cursors' " 多重选择
Plugin 'scrooloose/nerdcommenter' " 快速注释
Plugin 'tpope/vim-repeat'         " 重复上次操作
"Plugin 'godlygeek/tabular'       " 快速对齐
"Plugin 'tpope/vim-surround'      " 快速引号包围

Plugin 'SirVer/ultisnips'         " 片段引擎
Plugin 'honza/vim-snippets'       " 片段库

"Plugin 'vim-airline/vim-airline' " 状态栏

"插件安装结束#######################################################

call vundle#end()                 " required
filetype plugin indent on         " required

"插件配置#######################################################
" NERDTree配置
nmap nt :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif  "自动关闭
let g:NERDTreeWinSize=20                          " 窗口宽度(31)

" Tagbar配置
nmap tb :TagbarToggle<CR>
let g:tagbar_width = 20                           " 窗口宽度(40)

" Lisp配置
let g:slimv_swank_cmd = '! xterm -e sbcl --load /home/ding/.vim/bundle/slimv/slime/start-swank.lisp &'
let g:slimv_impl = 'sbcl'
let g:slimv_preferred = 'sbcl'
let g:paredit_electric_return=0                   "禁止此功能
"let g:paredit_mode=0
let g:lisp_rainbow=1                              " 彩虹括号匹配
let g:lisp_menu=1
let g:swank_block_size = 65536
let g:slimv_unmap_tab = 1                         " 禁止绑定tab键
let g:slimv_repl_split=4                          " 竖直分裂窗口
let g:slimv_echolines=1

" YouCompleteMe配置
let g:ycm_global_ycm_extra_conf='~/.ycm_extra_conf.py'     " 全局配置文件
let g:ycm_key_list_select_completion=['<c-n>','<down>']    " youcompleteme  默认tab  s-tab 和自动补全冲突
let g:ycm_key_list_previous_completion=['<c-p>','<up>']
let g:ycm_key_invoke_completion = '<C-Space>'     " 进行语义补全
let g:ycm_min_num_of_chars_for_completion=1       " 从第1个键入字符就开始罗列匹配项
let g:ycm_seed_identifiers_with_syntax=1          " 语法关键字补全
let g:ycm_complete_in_comments = 1                " 在注释输入中也能补全
let g:ycm_complete_in_strings = 1                 " 在字符串输入中也能补全
let g:ycm_collect_identifiers_from_comments_and_strings = 0 " 注释和字符串中的文字也收入补全
let g:ycm_collect_identifiers_from_tags_files=1   " 开启标签引擎
let g:ycm_confirm_extra_conf=0                    " 关闭加载.ycm_extra_conf.py提示 
let g:ycm_enable_diagnostic_signs = 0             " 关闭错误诊断侧向标记 
let g:ycm_cache_omnifunc=0                        " 禁止缓存匹配项,每次都重新生成匹配项

" Tern.js配置
let g:tern_show_signature_in_pum=1               " 显示函数参数提示

" Emmet配置
let g:user_emmet_leader_key = '<leader>'          " Emmet触发按键(<c-y>)
let g:emmet_html5 = 1                             " 使用HTML5标准风格
let g:user_emmet_install_global = 0               " 全局关闭

" UltiSnips配置
"let g:UltiSnipsExpandTrigger="<leader><tab>"
let g:UltiSnipsJumpForwardTrigger='<leader>n'
let g:UltiSnipsJumpBackwardTrgger='<leader>N'
"let g:UltiSnipsListSnippets="<c-e>"
let g:UltiSnipsEnableSnipMate=0                   "不使用snipMate的代码片段

"插件配置结束#######################################################
"""""""""""""""""""""""""""  结束  """""""""""""""""""""""""""


"""""""""""""""""""""""""""  系统  """""""""""""""""""""""""""
" 取消自动备份
"set noundofile
"set nobackup
"set noswapfile

" 失去焦点自动保存当前文件
au FocusLost * :up
"au FocusLost * silent! up 

" 让配置变更立即生效
autocmd! BufWritePost ~/.vimrc source %

" 设置tags
set autochdir
set tags=tags;

" 自动补全
filetype plugin indent on
filetype on
set completeopt=longest,menu

" 鼠标操作
set mouse=a
set selection=exclusive
set selectmode=mouse,key

"""""""""""""""""""""""""""  结束  """""""""""""""""""""""""""


"""""""""""""""""""""""""""  ui  """""""""""""""""""""""""""
" 配色
set background=dark
if has("gui_running")  
	"colorscheme monokai
	colorscheme solarized
else 
	let g:solarized_termcolors=256
	let g:solarized_termtrans=1
	"colorscheme monokai
	colorscheme Tsolarized
	"colorscheme torte
	"colorscheme industry
endif

" 字体
set guifont=Monospace\ 14
"set guifont=CourierNew\ 16
"set guifont=Monospace:h14    "for Windows

" 行号
set number

" 总是显示状态栏
set laststatus=2

" 高亮光标所在行
set cursorline

" 高亮显示搜索结果
set hlsearch

" 禁止折行
"set nowrap

" 语法高亮
syntax enable
syntax on

" 禁止光标闪烁
"set gcr=a:block-blinkon0

" 禁止显示滚动条
" set guioptions-=l
" set guioptions-=L
" set guioptions-=r
" set guioptions-=R

" 禁止显示菜单和工具条
" set guioptions-=m
" set guioptions-=T

" 默认启动窗口最大化
if has("gui_running")
	set lines=999 columns=999
else
	if exists("+lines")
		set lines=50
	endif
	if exists("+columns")
		set columns=100
	endif
endif

" 终端光标闪烁
if has("gui_running") 

else
	if has("autocmd")
		au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
		au InsertEnter,InsertChange *
					\ if v:insertmode == 'i' | 
					\   silent execute '!echo -ne "\e[5 q"' | redraw! |
					\ elseif v:insertmode == 'r' |
					\   silent execute '!echo -ne "\e[3 q"' | redraw! |
					\ endif
		au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
	endif
endif

"""""""""""""""""""""""""""  结束  """""""""""""""""""""""""""


"""""""""""""""""""""""""""  文本格式化  """""""""""""""""""""""""""
" 缩进
set autoindent	
set cindent
set smartindent

" 缩进宽度
set tabstop=4
set softtabstop=4
set shiftwidth=2

" 基于缩进或语法进行代码折叠
"set foldmethod=indent
set foldmethod=syntax

" 启动 vim 时关闭折叠代码
set nofoldenable

"""""""""""""""""""""""""""  结束  """""""""""""""""""""""""""


"""""""""""""""""""""""""""  按键  """""""""""""""""""""""""""
" 修改<Leader>，默认为'\'
let mapleader=","

" 多文件之间切换
nnoremap <silent> <F8> :bn!<CR> 

" buffer窗口最大化
nnoremap <F11> <c-w>\|

" buffer窗口等宽度排列
nnoremap <F12> <c-w>=

" 自动补全括号
func! Bracket()
	inoremap ( ()<left>
	inoremap [ []<left>
	"inoremap { {}<left><CR><up><right><CR>
	inoremap { {}<left><CR><up><esc>o
	"inoremap { {}<left><left><CR><right><CR><up><right><CR>
	inoremap } {}<left>
	inoremap " ""<left>
	inoremap ' ''<left>
	inoremap <S-Tab> <right>
endfunc
autocmd! FileType c,cpp,sh,python,html,css,javascript,json call Bracket()
autocmd FileType html,css,scss EmmetInstall       " 仅html,css,scss等开启

" 上下左右按键
nnoremap i k
nnoremap k j
nnoremap j h
nnoremap h i
nnoremap H I
vnoremap i k
vnoremap k j
vnoremap j h
vnoremap h i
vnoremap H I

" 一键编译
map <F5> :call Compile()<CR>
func! Compile()  
	exec "w"  
	if &filetype == 'c'  
		"exec "!clear && gcc % -o ~/bin/bin/c/%<"  
		exec "! gcc % -o ~/bin/bin/c/%<"  
	elseif &filetype == 'cpp'  
		exec "!clear && g++ % -o ~/bin/bin/cpp/%<"  
	"elseif &filetype == 'java'   
		"exec "!clear &&  javac %"   
	"elseif &filetype == 'py'  
		"exec "! python %"  
	elseif &filetype == 'sh'  
		exec "! chmod a+x %"
	endif  
endfunc

" 一键运行
map <F6> :call Run()<CR>  
func! Run()  
	exec "w"      
	if &filetype == 'c'  
		exec "! ~/bin/bin/c/%<"       
	elseif &filetype == 'cpp'  
		exec "! ~/bin/bin/cpp/%<"  
	"elseif &filetype == 'java'   
		"exec "!clear && java ~/bin/bin/java/%<"  
	"elseif &filetype == 'py'  
		"exec "! python ./%"  
	elseif &filetype == 'sh'  
		exec "! ./%"  
	endif  
endfunc  

" 一键debug
map <F7> :call RunGdb()<CR>  
func! RunGdb()  
	exec "w"  
	exec "! gcc % -g -o ~/bin/bin/c/%<"  
	exec "! gdb ~/bin/bin/c/%<" 
endfunc  

"""""""""""""""""""""""""""  结束  """""""""""""""""""""""""""

