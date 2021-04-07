"======================================================================
"
" 插件
"
"======================================================================


"----------------------------------------------------------------------
" 在 ~/.vim/plugged 下安装插件
"----------------------------------------------------------------------
call plug#begin(get(g:, 'bundle_home', '~/.vim/plugged'))


"----------------------------------------------------------------------
" 基础配置
"----------------------------------------------------------------------
"--------------------------------
" workspace or session
"--------------------------------
" Plug 'thaerkh/vim-workspace'"

" let g:workspace_autocreate =1
" let g:workspace_session_disable_on_args = 1
" let g:workspace_session_directory = $HOME . '/.vim/.sessions/'
" let g:workspace_persist_undo_history = 0
" let g:workspace_undodir= $HOME . '/.vim/.undodir/'
" let g:workspace_autosave = 0
" let g:workspace_autosave_untrailspaces = 0

" nnoremap <space>ws :ToggleWorkspace<CR>

"--------------------------------
" 文件浏览
"--------------------------------
Plug 'scrooloose/nerdtree'

nnoremap <silent> <space>nn :NERDTreeFocus<CR>
nnoremap <silent> <space>nm :NERDTreeMirror<CR>

" 自动关闭
autocmd bufenter * if (winnr("$") ==? 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" 窗口宽度(31)
let g:NERDTreeWinSize=35
let g:NERDTreeWinSizeMax=35
" 打开文件后自动关闭
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeHijackNetrw = 0

"--------------------------------
" 文件复制移动删除
"--------------------------------
Plug 'PhilRunninger/nerdtree-visual-selection'

"--------------------------------
" clean hidden buffer
"--------------------------------
Plug 'Asheq/close-buffers.vim'


"--------------------------------
" outline
"--------------------------------
Plug 'majutsushi/tagbar'

nnoremap <silent> <space>tb :TagbarToggle<CR>
" 窗口宽度(40)
let g:tagbar_width=20

"--------------------------------
" 模糊搜索
"--------------------------------
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf

nnoremap <space>ff :Files<cr>
nnoremap <space>fg :GFiles<cr>
nnoremap <space>fr :Rg
nnoremap <space>fh :History<cr>

"--------------------------------
" editorconfig
"--------------------------------
Plug 'editorconfig/editorconfig-vim'

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']


"----------------------------------------------------------------------
" 辅助操作
"----------------------------------------------------------------------
"--------------------------------
" 括号补全
"--------------------------------
Plug 'jiangmiao/auto-pairs'

" let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutToggle = ''

"--------------------------------
" 光标快速跳转
"--------------------------------
Plug 'easymotion/vim-easymotion'

let g:EasyMotion_leader_key='<leader><leader>'
let g:EasyMotion_smartcase=1
noremap <leader>w <Plug>(easymotion-W)
noremap <leader>e <Plug>(easymotion-E)
noremap <leader>b <Plug>(easymotion-B)

"--------------------------------
" sublime中multiple
"--------------------------------
Plug 'terryma/vim-multiple-cursors'

"--------------------------------
" 快速注释
"--------------------------------
Plug 'scrooloose/nerdcommenter'

" 注释间增加空格
let g:NERDSpaceDelims=1
" 取消注释时移除空格
let g:NERDRemoveExtraSpaces=1
" 针对vue文件
let g:ft=''
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

"--------------------------------
" 重复上次操作
"--------------------------------
Plug 'tpope/vim-repeat'

"--------------------------------
" 快速符号包围
"--------------------------------
Plug 'tpope/vim-surround'


"----------------------------------------------------------------------
" 智能补全
"----------------------------------------------------------------------
"--------------------------------
" coc插件系统
"--------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}

let g:coc_config_home = "~/Git/config/Vim/coc/"

let g:coc_global_extensions = [
      \ "coc-calc",
      \ "coc-css",
      \ "coc-emmet",
      \ "coc-emoji",
      \ "coc-html",
      \ "coc-json",
      \ "coc-marketplace",
      \ "coc-prettier",
      \ "coc-sh",
      \ "coc-snippets",
      \ "coc-tabnine",
      \ "coc-tsserver",
      \ "coc-ultisnips",
      \ "coc-vetur",
      \ "coc-vimlsp",
      \ "coc-yaml"
      \]

set sessionoptions+=globals

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <c-space> coc#refresh()
if !has("gui_running")
  inoremap <silent><expr> <NUL> coc#refresh()
endif

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" list
nnoremap <silent> <space>li :<C-u>CocList --normal<CR>
nnoremap <silent> <space>lx :<C-u>CocList --normal extensions<CR>

" coc-css
autocmd FileType scss setl iskeyword+=@-@"

" coc-prettier
noremap <c-s-i> :<c-u>CocCommand prettier.formatFile<cr>


" nmap <space>coa  <Plug>(coc-codeaction)
nmap <space>coa  :<c-u>CocAction<cr>
nmap <space>cof  <Plug>(coc-fix-current)
nmap <space>cor  <Plug>(coc-rename)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

"--------------------------------
" html、css补全
"--------------------------------
Plug 'mattn/emmet-vim'
" Emmet触发按键(<c-y>)
let g:user_emmet_leader_key='<leader>'
" 使用HTML5标准风格
let g:emmet_html5=1
" 全局开启
let g:user_emmet_install_global=1
" 特定文件开启emmet
" autocmd FileType html,css,sass,scss,less,vue,jsx,markdown,wxml,wxss EmmetInstall

"--------------------------------
" 代码片段
"--------------------------------
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"let g:UltiSnipsExpandTrigger="<leader><tab>"
let g:UltiSnipsJumpForwardTrigger='<leader>n'
let g:UltiSnipsJumpBackwardTrgger='<leader>N'
"let g:UltiSnipsListSnippets="<c-e>"
" 不使用snipMate的代码片段
let g:UltiSnipsEnableSnipMate=0


"----------------------------------------------------------------------
" 类型扩展
"----------------------------------------------------------------------
"--------------------------------
" css
"--------------------------------
Plug 'hail2u/vim-css3-syntax'

"--------------------------------
" javascript
"--------------------------------
Plug 'pangloss/vim-javascript'

let g:javascript_plugin_jsdoc=1

Plug 'jelera/vim-javascript-syntax'

" 语法高亮优化
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

"--------------------------------
" typescript
"--------------------------------
" Plug 'leafgarland/typescript-vim'

" let g:typescript_ignore_browserwords=1

Plug 'herringtondarkholme/yats.vim'

"--------------------------------
" vue
"--------------------------------
Plug 'posva/vim-vue'

" autocmd FileType vue syntax sync fromstart
" autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
let g:vue_disable_pre_processors=1

"--------------------------------
" jsx
"--------------------------------
" Plug 'mxw/vim-jsx'

Plug 'maxmellon/vim-jsx-pretty'

"--------------------------------
" markdown
"--------------------------------
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'mzlogin/vim-markdown-toc'

" let g:mkdp_refresh_slow = 1
let g:mkdp_auto_close = 1

autocmd FIleType markdown nmap <silent> <space>md <Plug>MarkdownPreviewToggle
function! g:Open_browser(url)
  silent exec "silent !google-chrome --app=" . a:url
endfunction
let g:mkdp_browserfunc = 'g:Open_browser'

autocmd FIleType markdown nnoremap <silent> <space>to :GenTocGFM<cr>

"--------------------------------
" Lisp
"--------------------------------
" Plug 'kovisoft/slimv'

let g:slimv_swank_cmd=g:var_slimv_swank_cmd
let g:slimv_impl='sbcl'
let g:slimv_preferred='sbcl'
"禁止此功能
let g:paredit_electric_return=0
" let g:paredit_mode=0
" 彩虹括号匹配
let g:lisp_rainbow=1
let g:lisp_menu=1
let g:swank_block_size=65536
" 禁止绑定tab键
let g:slimv_unmap_tab=1
" 竖直分裂窗口
let g:slimv_repl_split=4
let g:slimv_echolines=1

"----------------------------------------------------------------------
" 语法检查
"----------------------------------------------------------------------
"--------------------------------
" ALE
"--------------------------------


"----------------------------------------------------------------------
" 界面主题
"----------------------------------------------------------------------
"--------------------------------
" 主题配色
"--------------------------------
Plug 'lifepillar/vim-solarized8'

let g:solarized_termcolors=256
let g:solarized_termtrans=1
let g:solarized_statusline="flat"

"--------------------------------
" 状态栏
"--------------------------------
Plug 'vim-airline/vim-airline'

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_powerline_fonts = 1
let g:airline_exclude_preview = 1
let g:airline_highlighting_cache = 1
let g:airline_extensions = ["coc"]

"--------------------------------
" 窗口大小自动调整
"--------------------------------
" Plug 'roman/golden-ratio'

" let g:golden_ratio_exclude_nonmodifiable = 1

"--------------------------------
" 缩进标识
"--------------------------------
Plug 'yggdroot/indentline'

let g:indentLine_char_list=['|', '¦', '┆', '┊']
autocmd FileType json,markdown let g:indentLine_setConceal=0

"--------------------------------
" 彩虹括号
"--------------------------------
" WARNING: may add ugly square brackets to devicons
" Plug 'luochen1990/rainbow'

let g:rainbow_active = 1
let g:rainbow_conf = {
      \ 'guifgs': ['red1', 'orange1', 'yellow1', 'greenyellow', 'green1', 'springgreen1', 'cyan1', 'slateblue1', 'magenta1', 'purple1'],
      \ 'ctermfgs': ['red', 'yellow', 'green', 'cyan', 'magenta'],
      \ 'operators': '_,_',
      \ 'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
      \ 'separately': {
      \  '*': {},
      \  'tex': {
      \   'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
      \  },
      \  'lisp': 0,
      \  'vim': {
      \   'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
      \  },
      \  'html': 0,
      \  'css': 0,
      \ }
      \}

"--------------------------------
" 开始界面
"--------------------------------
Plug 'mhinz/vim-startify'

let g:startify_change_to_dir = 1
let g:startify_session_dir="~/.vim/.sessions"
let g:startify_session_autoload = 1
let g:startify_session_sort = 1
let g:startify_session_persistence = 1
" 清除无用buffers
let g:startify_session_savecmds = [
      \ 'silent Bdelete hidden'
      \ ]
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
let g:startify_custom_header = ['']
" let g:ascii = ['']
" let g:startify_custom_header =
" \ 'startify#pad(g:ascii + startify#fortune#quote())'

"--------------------------------
" 文件图标
"--------------------------------
Plug 'ryanoasis/vim-devicons'

let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ''

"--------------------------------
" 文件图标颜色高亮
"--------------------------------
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightCursorline = 0


"----------------------------------------------------------------------
" Git集成
"----------------------------------------------------------------------
"--------------------------------
" git操作
"--------------------------------
Plug 'tpope/vim-fugitive'

"--------------------------------
" 边栏显示git状态
"--------------------------------
Plug 'airblade/vim-gitgutter'

let g:gitgutter_map_keys = 0

"----------------------------------------------------------------------
" 其他
"----------------------------------------------------------------------
"--------------------------------
" vim中文文档
"--------------------------------
Plug 'yianwillis/vimcdoc'

"--------------------------------
"--------------------------------
" task任务执行
"--------------------------------
Plug 'skywind3000/asyncrun.vim', { 'on': ['AsyncRun', 'AsyncStop'] }
Plug 'skywind3000/asynctasks.vim', { 'on': ['AsyncTask', 'AsyncTaskMacro', 'AsyncTaskList', 'AsyncTaskEdit'] }

let g:asyncrun_open = 6
let g:asynctasks_term_pos = 'bottom'
noremap <silent> <f4> :AsyncTask file-build<cr>
noremap <silent> <f5> :AsyncTask file-run<cr>

"--------------------------------
" live server
"--------------------------------
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}

noremap <space>lvv :Bracey<cr>
noremap <space>lvs :BraceyStop<cr>

"--------------------------------
" jsoc
"--------------------------------

"--------------------------------
" 本地和远程服务器文件同步
"--------------------------------
" Plug 'b2ns/vim-syncr'


"----------------------------------------------------------------------
" 结束插件安装
"----------------------------------------------------------------------
call plug#end()

