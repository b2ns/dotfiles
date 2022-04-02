"======================================================================
"
" 插件
"
"======================================================================

"----------------------------------------------------------------------
" 在 ~/.vim/plugged 下安装插件
"----------------------------------------------------------------------
let g:plug_timeout=10
let g:plug_retries=6

call plug#begin(get(g:, 'bundle_home', '~/.vim/plugged'))

"----------------------------------------------------------------------
" 基础配置
"----------------------------------------------------------------------
"--------------------------------
" 文件浏览
"--------------------------------
" Plug 'preservim/nerdtree'

" nnoremap <silent> <space>nn :NERDTreeFocus<CR>
" nnoremap <silent> <space>nm :NERDTreeMirror<CR>

" 自动关闭
autocmd bufenter * if (winnr("$") ==? 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" 窗口宽度(31)
let g:NERDTreeWinSize=45
" 打开文件后自动关闭
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeHijackNetrw = 0

"--------------------------------
" 文件复制移动删除
"--------------------------------
" Plug 'PhilRunninger/nerdtree-visual-selection'

"--------------------------------
" clean hidden buffer
"--------------------------------
Plug 'Asheq/close-buffers.vim'


"--------------------------------
" tags
"--------------------------------
" Plug 'majutsushi/tagbar'
Plug 'ludovicchabant/vim-gutentags'
" Plug 'skywind3000/gutentags_plus'
let g:gutentags_cache_dir = expand('~/.cache/tags')
let g:gutentags_ctags_exclude=['.git', 'node_modules', 'log', 'db']

" nnoremap <silent> <space>tb :TagbarToggle<CR>
" " 窗口宽度(40)
" let g:tagbar_width=20

"--------------------------------
" 模糊搜索
"--------------------------------
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf

nnoremap <space>ff :Files<cr>
nnoremap <space>fh :History<cr>
nnoremap <space>fb :Buffers<cr>
nnoremap <space>fr :Rg
nnoremap <space>fg :GFiles<cr>
nnoremap <space>fm :Commits<cr>

"--------------------------------
" editorconfig
"--------------------------------
" Plug 'editorconfig/editorconfig-vim'

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

"--------------------------------
" 书签
"--------------------------------
Plug 'MattesGroeger/vim-bookmarks'

"--------------------------------
" 翻译
"--------------------------------


"----------------------------------------------------------------------
" 辅助操作
"----------------------------------------------------------------------
"--------------------------------
" 括号补全
"--------------------------------
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsMapCh=0
let g:AutoPairsMoveCharacter=''

"--------------------------------
" 光标快速跳转
"--------------------------------
Plug 'easymotion/vim-easymotion'

let g:EasyMotion_leader_key='<leader><leader>'
let g:EasyMotion_smartcase=1
nnoremap <leader>w <Plug>(easymotion-W)
nnoremap <leader>e <Plug>(easymotion-E)
nnoremap <leader>b <Plug>(easymotion-B)

"--------------------------------
" multiple cursor
"--------------------------------
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

"--------------------------------
" 快速注释
"--------------------------------
Plug 'preservim/nerdcommenter'

" 注释间增加空格
let g:NERDSpaceDelims=1
" 取消注释时移除空格
let g:NERDRemoveExtraSpaces=1
" 针对vue文件
" let g:ft=''
" function! NERDCommenter_before()
  " if &ft ==? 'vue'
    " let g:ft='vue'
    " let stack=synstack(line('.'), col('.'))
    " if len(stack) > 0
      " let syn=synIDattr((stack)[0], 'name')
      " if len(syn) > 0
        " exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      " endif
    " endif
  " endif
" endfunction
" function! NERDCommenter_after()
  " if g:ft ==? 'vue'
    " setf vue
    " let g:ft=''
  " endif
" endfunction

"--------------------------------
" 重复上次操作
"--------------------------------
Plug 'tpope/vim-repeat'

"--------------------------------
" 快速符号包围
"--------------------------------
Plug 'tpope/vim-surround'

"--------------------------------
" auto close tag
"--------------------------------
Plug 'AndrewRadev/tagalong.vim'

"--------------------------------
" 对齐
"--------------------------------
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

"----------------------------------------------------------------------
" 智能补全
"----------------------------------------------------------------------
"--------------------------------
" coc插件系统
"--------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}

let g:coc_config_home = "~/github/b2ns/config/Vim/coc/"

let g:coc_snippet_next = '<tab>'

let g:coc_global_extensions = [
      \ "coc-calc",
      \ "coc-css",
      \ "coc-cssmodules",
      \ "coc-emmet",
      \ "coc-emoji",
      \ "coc-html",
      \ "coc-html-css-support",
      \ "coc-json",
      \ "coc-lightbulb",
      \ "coc-marketplace",
      \ "coc-prettier",
      \ "coc-sh",
      \ "coc-tsserver",
      \ "coc-vetur",
      \ "@yaegassy/coc-volar",
      \ "coc-vimlsp",
      \ "coc-yaml",
      \ "coc-java",
      \ "coc-java-debug",
      \ "coc-snippets",
      \ "coc-explorer",
      \ "coc-highlight",
      \ "coc-markdownlint",
      \ "coc-markmap",
      \ "@yaegassy/coc-nginx",
      \ "coc-spell-checker",
      \ "coc-sql",
      \ "coc-tasks",
      \ "coc-yank",
      \ "coc-db",
      \ "coc-floaterm",
      \ "coc-word",
      \ "coc-dictionary",
      \ "coc-tag",
      \]
      " \ "coc-tabnine",

" coc-explorer
nnoremap <silent> <space>nn <Cmd>CocCommand explorer --quit-on-open --position left --width 50<CR>

" coc-markmap
command! -range=% Markmap CocCommand markmap.create <line1> <line2>

" coc-css
autocmd FileType scss setl iskeyword+=@-@"


" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  " inoremap <silent><expr> <c-@> coc#refresh()
  inoremap <silent><expr> <c-space> coc#refresh()
endif
if !has("gui_running")
  inoremap <silent><expr> <NUL> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
set termguicolors

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:ORI` command for organize imports of the current buffer.
command! -nargs=0 ORI :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}


" list
nnoremap <silent><nowait> <space>li :<C-u>CocList<cr>
nnoremap <silent><nowait> <space>ll :<C-u>CocListResume<cr>
nnoremap <silent><nowait> <space>lx :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>lc :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>le :<C-u>CocList diagnostics<cr>
" nnoremap <silent><nowait> <space>lo :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>lo :<C-u>CocOutline<cr>
nnoremap <silent><nowait> <space>ls :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>ly :<C-u>CocList -A --normal yank<cr>
nnoremap <silent><nowait> <space>lt :<C-u>CocList --normal floaterm<cr>

" Do default action for next item.
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>

" nmap <c-a-i> <Plug>(coc-format)
nmap <c-a-i> :<c-u>Format<cr>
nmap <c-a-o> :<c-u>ORI<cr>
nmap <c-a-m> :CocCommand 
nmap <c-a-c> :<c-u>CocConfig<cr>
nmap <c-a-r> :CocSearch 

nmap <space>ca <Plug>(coc-codeaction)
vmap <space>ca  <Plug>(coc-codeaction-selected)
nmap <space>cla  <Plug>(coc-codelens-action)
nmap <space>cf <Plug>(coc-fix-current)
nmap <space>cr <Plug>(coc-rename)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

"--------------------------------
" html、css补全
"--------------------------------
Plug 'mattn/emmet-vim'
" let g:user_emmet_leader_key='<leader>'
let g:user_emmet_mode='i'
let g:user_emmet_install_global=1
" 特定文件开启emmet
" autocmd FileType html,css,sass,scss,less,vue,jsx,markdown,wxml,wxss EmmetInstall

"--------------------------------
" 代码片段
"--------------------------------
Plug 'honza/vim-snippets'
" Plug 'SirVer/ultisnips'

"let g:UltiSnipsExpandTrigger="<leader><tab>"
" let g:UltiSnipsJumpForwardTrigger='<leader>n'
" let g:UltiSnipsJumpBackwardTrgger='<leader>N'
"let g:UltiSnipsListSnippets="<c-e>"
" 不使用snipMate的代码片段
" let g:UltiSnipsEnableSnipMate=0

"--------------------------------
" 代码格式化
"--------------------------------
" noremap <c-a-i> :<c-u>call FormatCode()<cr>
" function! FormatCode()
  " if &ft ==? 'java'
    " call Formatcode#Run(g:var_formatter_java)
  " else
    " execute "CocCommand prettier.formatFile"
  " endif
" endfunction

"----------------------------------------------------------------------
" 类型扩展
"----------------------------------------------------------------------
"--------------------------------
" jsonc
"--------------------------------
" autocmd FileType json syntax match Comment +\/\/.\+$+
Plug 'neoclide/jsonc.vim'
autocmd BufRead,BufNewFile *.json set filetype=jsonc
" augroup JsonToJsonc
  " autocmd! FileType json set filetype=jsonc
" augroup END

"--------------------------------
" css
"--------------------------------
Plug 'hail2u/vim-css3-syntax'

"--------------------------------
" javascript
"--------------------------------
Plug 'pangloss/vim-javascript'

let g:javascript_plugin_jsdoc=1

" Plug 'jelera/vim-javascript-syntax'

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
" Plug 'posva/vim-vue'
" let g:vue_disable_pre_processors=1
" autocmd FileType vue syntax sync fromstart
" autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css

Plug 'leafOfTree/vim-vue-plugin'
let g:vim_vue_plugin_config = {
      \'syntax': {
        \   'template': ['html'],
        \   'script': ['javascript', 'typescript'],
        \   'style': ['css', 'less', 'scss'],
        \},
        \'attribute': 1,
        \'keyword': 1,
        \'foldexpr': 0,
        \'debug': 0,
        \}
" function! OnChangeVueSyntax(syntax)
" " echom 'Syntax is '.a:syntax
" if a:syntax == 'html'
" setlocal commentstring=<!--%s-->
" setlocal comments=s:<!--,m:\ \ \ \ ,e:-->
" elseif a:syntax =~ 'css' || a:syntax =~ 'less' || a:syntax =~ 'scss'
" setlocal comments=s1:/*,mb:*,ex:*/ commentstring&
" else
" setlocal commentstring=//%s
" setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
" endif
" endfunction

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
" java
"--------------------------------
Plug 'uiiaoo/java-syntax.vim'

"--------------------------------
" 数据库
"--------------------------------
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

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
" Plug 'lifepillar/vim-solarized8'
" let g:solarized_termcolors=256
" let g:solarized_termtrans=1
" let g:solarized_statusline="flat"

Plug 'sainnhe/everforest'
let g:everforest_better_performance=1
let g:everforest_background='hard'
let g:everforest_ui_contrast='hight'
let g:everforest_enable_italic=1

Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'patstockwell/vim-monokai-tasty'
let g:vim_monokai_tasty_italic = 1

Plug 'NLKNguyen/papercolor-theme'

Plug 'sonph/onehalf', {'rtp': 'vim/'}

nmap <silent> <f3> :call <sid>ToggleBackground()<cr>
nmap <silent> <c-f3> :call <sid>ChangeColorscheme("next")<cr>
nmap <silent> <s-f3> :call <sid>ChangeColorscheme("pre")<cr>

" 定义哪些主题具有light模式，避免不支持该模式的主题切换到该模式
let g:var_has_light_mode_colorscheme=['everforest', 'PaperColor', 'onehalflight']

function s:ToggleBackground()
  let colorscheme=g:UTILGetColorscheme()
  let background=g:UTILToggleBackground()
  if !empty(background)
    call g:UTILLocalStorageSet('background', background)
    let timer = timer_start(0, {-> execute("echo '" . colorscheme . ': ' . background . "'", "")})
  endif
endfunction

function s:ChangeColorscheme(nextOrPre)
  let colorscheme=""
  if a:nextOrPre == "next"
    let colorscheme=g:UTILNextColorscheme()
  else
    let colorscheme=g:UTILPreColorscheme()
  endif

  if !empty(colorscheme)
    call g:UTILLocalStorageSet('colorscheme', colorscheme)
    let timer = timer_start(0, {-> execute("echo '" . colorscheme . ': ' . &background . "'", "")})
  endif
endfunction

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
let g:indentLine_fileTypeExclude=['coc-explorer']

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
" Plug 'ryanoasis/vim-devicons'

" let g:webdevicons_conceal_nerdtree_brackets = 1
" let g:WebDevIconsUnicodeDecorateFolderNodes = 1
" let g:WebDevIconsNerdTreeAfterGlyphPadding = ''

"--------------------------------
" 文件图标颜色高亮
"--------------------------------
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" let g:NERDTreeFileExtensionHighlightFullName = 1
" let g:NERDTreeExactMatchHighlightFullName = 1
" let g:NERDTreePatternMatchHighlightFullName = 1
" let g:NERDTreeHighlightCursorline = 0


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

"--------------------------------
" git blame
"--------------------------------
Plug 'APZelos/blamer.nvim'
let g:blamer_enabled = 0
let g:blamer_delay = 1000
let g:blamer_show_in_visual_modes = 0
let g:blamer_show_in_insert_modes = 0
let g:blamer_date_format = '%Y/%m/%d %H:%M'

"--------------------------------
" 查看commit
"--------------------------------
Plug 'junegunn/gv.vim'

"----------------------------------------------------------------------
" 其他
"----------------------------------------------------------------------
"--------------------------------
" vim中文文档
"--------------------------------
Plug 'yianwillis/vimcdoc'

"--------------------------------
"--------------------------------
" 终端
"--------------------------------
Plug 'voldikss/vim-floaterm'
" let g:floaterm_wintype='vsplit'
let g:floaterm_position='bottomright'
let g:floaterm_width=0.5
let g:floaterm_height=1.0
let g:floaterm_borderchars='-│-│┌┐┘└'
let g:floaterm_opener='tabe'
let g:floaterm_keymap_toggle = '<c-a-t>'

"--------------------------------
" task任务执行
"--------------------------------
Plug 'skywind3000/asyncrun.vim', { 'on': ['AsyncRun', 'AsyncStop'] }
Plug 'skywind3000/asynctasks.vim', { 'on': ['AsyncTask', 'AsyncTaskMacro', 'AsyncTaskList', 'AsyncTaskEdit'] }

let g:asyncrun_open = 6
" let g:asynctasks_term_pos = 'external'
" let g:asynctasks_term_reuse=1
" let g:asynctasks_term_focus=0
nnoremap <silent> <f4> :AsyncTask build<cr>
nnoremap <silent> <f5> :AsyncTask run<cr>

"--------------------------------
" live server
"--------------------------------
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}

nnoremap <space>lvv :Bracey<cr>
nnoremap <space>lvs :BraceyStop<cr>

"--------------------------------
" 本地和远程服务器文件同步
"--------------------------------
" Plug 'b2ns/vim-syncr'

"--------------------------------
" debug
"--------------------------------
Plug 'puremourning/vimspector'
let g:vimspector_sign_priority = {
  \    'vimspectorBP':         999,
  \    'vimspectorBPCond':     999,
  \    'vimspectorBPLog':      999,
  \    'vimspectorBPDisabled': 999,
  \    'vimspectorPC':         999,
  \ }
let g:vimspector_sidebar_width = 30
let g:vimspector_bottombar_height = 10
let g:vimspector_terminal_minwidth = 20
" let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
nmap <silent> <F6> <Plug>VimspectorToggleBreakpoint
nmap <silent> <c-F6> <Plug>VimspectorToggleConditionalBreakpoint
nmap <silent> <s-F6> <Plug>VimspectorAddFunctionBreakpoint
nmap <silent> <F7> <Plug>VimspectorContinue
nmap <silent> <c-F7> <Plug>VimspectorRestart
nmap <silent> <s-F7> <Plug>VimspectorStop
nmap <silent> <F8> <Plug>VimspectorStepOver
nmap <silent> <c-F8> <Plug>VimspectorStepInto
nmap <silent> <s-F8> <Plug>VimspectorStepOut
nmap <silent> <F9> <Plug>VimspectorGoToCurrentLine
nmap <silent> <c-F9> <Plug>VimspectorRunToCursor
" nmap <silent> <F9> <Plug>VimspectorPause

function s:JavaStartDebug()
  call system("javac -g " . expand('%:t'))
  call system("java -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5005 " . expand('%:r:t') . " &")
  execute "CocCommand java.debug.vimspector.start"
endfunction

nmap <F1> gg:call <sid>JavaStartDebug()<CR>

"--------------------------------
" test
"--------------------------------

"----------------------------------------------------------------------
" 结束插件安装
"----------------------------------------------------------------------
call plug#end()
