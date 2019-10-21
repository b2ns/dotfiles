"""""""""""""""""""""""""""""""""""""""""""
" Description: my configration for Vim    "
" Author: b2ns                            "
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""  不同环境配置  """""""""""""""""""""""""""
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os="Windows"
    else
        let g:os=substitute(system('uname -s'), '\n', '', '')
    endif
endif

if g:os ==? "Darwin" " for Mac
    let s:slimv_swank_cmd='!osascript -e "tell application \"Terminal\" to do script \"sbcl --load ~/.vim/bundle/slimv/slime/start-swank.lisp\""'
    let s:guifont="InconsolataLGC\ Nerd\ Font\ Mono:h18"
    let s:shiftwidth=4

elseif g:os ==? "Linux"
    let s:slimv_swank_cmd='! gnome-terminal -e "sbcl --load /home/ding/.vim/bundle/slimv/slime/start-swank.lisp &"'
    let s:guifont="InconsolataLGC\ Nerd\ Font\ Mono\ 16"
    let s:shiftwidth=4

elseif g:os ==? "Windows"

endif

"""""""""""""""""""""""""""  Vundle插件管理器  """""""""""""""""""""""""""
set nocompatible                   " required
filetype off                       " required

set rtp+=~/.vim/bundle/Vundle.vim  " set the runtime path to include Vundle and initialize

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'     " let Vundle manage Vundle, required

"插件安装#######################################################
Plugin 'yianwillis/vimcdoc'       " vim帮助中文文档
Plugin 'scrooloose/nerdtree'      " 文件浏览
Plugin 'ctrlpvim/ctrlp.vim'       " 文件查找
Plugin 'majutsushi/tagbar'        " 函数列表

" Plugin 'ervandew/supertab'        " YCM不可用时
Plugin 'kovisoft/slimv'           " Lisp
Plugin 'Valloric/YouCompleteMe'   " C/C++自动补全
Plugin 'pangloss/vim-javascript'  " javascript语法高亮
Plugin 'leafgarland/typescript-vim' " typescript高亮
Plugin 'mxw/vim-jsx'              " react-jsx语法高亮
Plugin 'mattn/emmet-vim'          " html、css、xml等补全
Plugin 'chemzqm/wxapp.vim'        " 小程序开发
Plugin 'posva/vim-vue'            " vue文件高亮
" Plugin 'davidhalter/jedi-vim'     " python补全引擎
" Plugin 'klen/python-mode'         " python高亮
"Plugin 'scrooloose/syntastic'    " 语法检查

Plugin 'SirVer/ultisnips'         " 片段引擎
Plugin 'honza/vim-snippets'       " 片段库

Plugin 'easymotion/vim-easymotion' " 快速跳转
Plugin 'terryma/vim-multiple-cursors' " 多重选择
Plugin 'scrooloose/nerdcommenter' " 快速注释
Plugin 'tpope/vim-repeat'         " 重复上次操作
Plugin 'godlygeek/tabular'       " 快速对齐
Plugin 'tpope/vim-surround'      " 快速引号包围
Plugin 'roman/golden-ratio'      " 窗口大小自动调整

Plugin 'yggdroot/indentline'      " 缩进标识
Plugin 'bling/vim-airline'        " 状态栏

Plugin 'b2ns/vim-syncr'           " 本地和远程服务器文件同步
"

call vundle#end()                 " required
filetype plugin indent on         " required

"插件配置#######################################################
" NERDTree
nnoremap mt :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") ==? 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif  "自动关闭
let g:NERDTreeWinSize=20                          " 窗口宽度(31)
let g:NERDTreeQuitOnOpen=1                        " 打开文件后自动关闭

" Ctrlp


" Tagbar
nnoremap tb :TagbarToggle<CR>
let g:tagbar_width=20                           " 窗口宽度(40)

" Lisp
let g:slimv_swank_cmd=s:slimv_swank_cmd
let g:slimv_impl='sbcl'
let g:slimv_preferred='sbcl'
let g:paredit_electric_return=0                   "禁止此功能
"let g:paredit_mode=0
let g:lisp_rainbow=1                              " 彩虹括号匹配
let g:lisp_menu=1
let g:swank_block_size=65536
let g:slimv_unmap_tab=1                         " 禁止绑定tab键
let g:slimv_repl_split=4                          " 竖直分裂窗口
let g:slimv_echolines=1

" YouCompleteMe
let g:ycm_global_ycm_extra_conf='~/.ycm_extra_conf.py'     " 全局配置文件
let g:ycm_key_list_select_completion=['<c-n>','<down>']    " youcompleteme  默认tab  s-tab 和自动补全冲突
let g:ycm_key_list_previous_completion=['<c-p>','<up>']
let g:ycm_key_invoke_completion='<C-Space>'     " 进行语义补全
let g:ycm_min_num_of_chars_for_completion=2       " 从第n个键入字符就开始罗列匹配项
let g:ycm_seed_identifiers_with_syntax=1          " 语法关键字补全
let g:ycm_complete_in_comments=1                " 在注释输入中补全
let g:ycm_complete_in_strings=1                 " 在字符串输入中补全
let g:ycm_collect_identifiers_from_comments_and_strings=1 " 注释和字符串中的文字收入补全
let g:ycm_collect_identifiers_from_tags_files=1   " 标签引擎
let g:ycm_confirm_extra_conf=0                    " 加载.ycm_extra_conf.py提示
let g:ycm_enable_diagnostic_signs=0             " 错误诊断侧向标记
let g:ycm_cache_omnifunc=1                        " 缓存匹配项
let g:ycm_filepath_blacklist={}                 " enable filepath completion in all file

" Emmet
let g:user_emmet_leader_key='<leader>'          " Emmet触发按键(<c-y>)
let g:emmet_html5=1                             " 使用HTML5标准风格
let g:user_emmet_install_global=1              " 全局开启
" autocmd FileType html,css,sass,scss,less,vue,jsx,markdown,wxml,wxss EmmetInstall       " 特定文件开启emmet

" javascript
let g:javascript_plugin_jsdoc=1

" typescript
let g:typescript_ignore_browserwords=1

" Vue
" autocmd FileType vue syntax sync fromstart
" autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
let g:vue_disable_pre_processors=1

" UltiSnips
"let g:UltiSnipsExpandTrigger="<leader><tab>"
let g:UltiSnipsJumpForwardTrigger='<leader>n'
let g:UltiSnipsJumpBackwardTrgger='<leader>N'
"let g:UltiSnipsListSnippets="<c-e>"
let g:UltiSnipsEnableSnipMate=0                   "不使用snipMate的代码片段

" Easymotion
let g:EasyMotion_leader_key='<leader>w'
let g:EasyMotion_smartcase=1
" map <leader> <Plug>(easymotion-prefix)          " prefix
map <leader>w <Plug>(easymotion-W)
map <leader>e <Plug>(easymotion-E)
map <leader>b <Plug>(easymotion-B)

" Multiple-cursors

" Nerdcommenter
let g:NERDSpaceDelims=1                           " 注释间增加空格
let g:NERDRemoveExtraSpaces=1                     " 取消注释时移除空格
let g:ft=''                                     " 针对vue文件
function! NERDCommenter_before()
  if &ft ==? 'vue'
    let g:ft='vue'
    let stack=synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn=synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction
function! NERDCommenter_after()
  if g:ft ==? 'vue'
    setf vue
    let g:ft=''
  endif
endfunction

" Tabularize

" indentline
let g:indentLine_char_list=['|', '¦', '┆', '┊']
autocmd FileType json let g:indentLine_setConceal=0

" airline
let g:airline_powerline_fonts=1


"""""""""""""""""""""""""""  系统  """""""""""""""""""""""""""
" 让配置变更立即生效
autocmd! BufWritePost $MYVIMRC source $MYVIMRC

" 设置字符编码
set encoding=UTF-8

" 取消自动备份
"set noundofile
"set nobackup
set noswapfile
set backupcopy=yes " 安全写入

" 失去焦点自动保存当前文件
autocmd FocusLost * :up

" 设置tags
set autochdir
set tags=tags;

" 自动补全
filetype plugin indent on
filetype on
set completeopt=longest,menu

" 鼠标操作
set mouse=a
set mousehide               " Hide the mouse cursor while typing
set selection=exclusive
set selectmode=mouse,key

" 解决backspace不能删除字符的bug
set backspace=indent,eol,start


"""""""""""""""""""""""""""  UI  """""""""""""""""""""""""""
" 配色
set background=dark
if has("gui_running")
    "colorscheme monokai
    colorscheme solarized
else
    set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
    "colorscheme monokai
    colorscheme solarized
    " colorscheme torte
    " colorscheme industry
endif

" 字体
let &guifont=s:guifont

" 行号
set number

" 总是显示状态栏
set laststatus=2

" 高亮光标所在行
set cursorline

" 高亮配对的符号
set showmatch                   " Show matching brackets/parenthesis

" 高亮显示搜索结果
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set ignorecase                  " Case insensitive search
set smartcase
set nowrapscan

" 补全列表
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too

" 显示控制符
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" 禁止折行
"set nowrap

" 语法高亮
syntax enable
syntax on

" 禁止光标闪烁
"set gcr=a:block-blinkon0

" 禁止显示滚动条
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

" 禁止显示菜单和工具条
"set guioptions-=m
set guioptions-=T

" 默认启动窗口最大化
if has("gui_running")
    set lines=999 columns=999
else
    if exists("+lines")
        set lines=40
    endif
    if exists("+columns")
        set columns=120
    endif
endif

" 终端光标闪烁
if !has("gui_running")
    if has("autocmd")
        autocmd VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
        autocmd InsertEnter,InsertChange *
                    \ if v:insertmode ==? 'i' |
                    \   silent execute '!echo -ne "\e[5 q"' | redraw! |
                    \ elseif v:insertmode ==? 'r' |
                    \   silent execute '!echo -ne "\e[3 q"' | redraw! |
                    \ endif
        autocmd VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
    endif
endif


"""""""""""""""""""""""""""  文本格式化  """""""""""""""""""""""""""
" 缩进
set autoindent
set cindent
set smartindent

" 缩进宽度
let &shiftwidth=s:shiftwidth
set tabstop=4
set softtabstop=4
set expandtab

" 基于缩进或语法进行代码折叠
"set foldmethod=indent
set foldmethod=syntax

" 启动 vim 时关闭折叠代码
set nofoldenable

" 多行合并时没有空格
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)

" 去除空行的多余空格
set linespace=0                 " No extra spaces between rows


"""""""""""""""""""""""""""  按键  """""""""""""""""""""""""""
" 修改<Leader>，默认为'\'
let mapleader=","

" 反向查找
noremap \ ,

" 全选
" nnoremap <c-a> ggVG

" 从系统剪贴板粘贴
noremap <c-v> "+gP

" 复制到系统剪切板
vnoremap <c-c> "+y

" 自动补全配对符号
inoremap ( ()<left>
inoremap ) ();<left><left>
inoremap [ []<left>
inoremap ] [];<left><left>
" inoremap { {}<left><CR><up><esc>o
inoremap { {}<left>
inoremap } {};<left><left>
inoremap " ""<left>
inoremap ' ''<left>
inoremap ` ``<left>

" lisp中取消某些按键绑定
function! ResetKeyMapping()
    inoremap ' '
    inoremap ` `
endfunction
autocmd FileType lisp,cl call ResetKeyMapping()

" 插入模式下移动光标
inoremap <s-cr> <cr><up><esc>o
inoremap <s-tab> <right>

" 上下左右按键
noremap i <up>
noremap k <down>
noremap j <left>
noremap h i
noremap H I

" 整行上下移动
noremap <a-i> :.m--<cr>
noremap <a-k> :.m+<cr>

" 通用正则搜索
noremap / /\v
noremap ? ?\v

" 重复上次替换
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" 清空查找高亮
nnoremap <silent> <c-l> :<c-u>nohlsearch<cr><c-l>

" 命令行历史
cnoremap <c-p> <up>
cnoremap <c-n> <down>

" nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>
function! s:GrepOperator(type)
    let saved_unnamed_register=@@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    silent execute "grep! -R " . shellescape(@@) . " ."
    copen

    let @@=saved_unnamed_register
endfunction

" 一键编译
map <f5> :call Compile()<cr>
function! Compile()
    execute "w"
    if &filetype ==? 'c'
        execute "! gcc % -o ~/bin/c/%:r"
    elseif &filetype ==? 'cpp'
        execute "! g++ % -o ~/bin/cpp/%:r"
    elseif &filetype ==? 'typescript'
        execute "! tsc % --outFile ~/bin/js/%:r.js"
    elseif &filetype ==? 'sh'
        execute "! chmod a+x %"
    endif
endfunction

" 一键运行
map <f6> :call Run()<cr>
function! Run()
    execute "w"
    if &filetype ==? 'c'
        execute "! ~/bin/c/%:r"
    elseif &filetype ==? 'cpp'
        execute "! ~/bin/cpp/%:r"
    elseif &filetype ==? 'javascript.jsx'
        execute "! node ./%"
    elseif &filetype ==? 'typescript'
        execute "! node ~/bin/js/%:r.js"
    elseif &filetype ==? 'sh'
        execute "! ./%"
    elseif &filetype ==? 'py'
        execute "! python ./%"
    endif
endfunction

" 一键debug
map <f7> :call Debug()<cr>
function! Debug()
    execute "w"
    execute "! gcc % -g -o ~/bin/c/%:r"
    execute "! gdb ~/bin/c/%:r"
endfunction

" 缩略词
" iabbrev dns domain name system

"""""""""""""""""""""""""""  其他  """""""""""""""""""""""""""
" 读取工程自定义.vimrc配置
function! GetCustomVimrc()
    let s:vimrcName = ".vimrc"
    let s:vimrcPath = findfile(s:vimrcName, fnameescape(expand("%:p:h")) . ";" . $HOME . "/")
    let s:vimrcPath = fnamemodify(s:vimrcPath, ":p")

    if s:vimrcPath != "" && s:vimrcName != fnamemodify(s:vimrcPath, ":t") && s:vimrcPath != $HOME . "/" . s:vimrcName
        execute "source ". s:vimrcPath
    endif
endfunction
autocmd BufRead,BufNewFile * call GetCustomVimrc()
