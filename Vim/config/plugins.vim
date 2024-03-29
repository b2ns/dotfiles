"======================================================================
"
" 插件
"
"======================================================================

"----------------------------------------------------------------------
" 在 ~/.vim/plugged 下安装插件
"----------------------------------------------------------------------
let g:plug_timeout=15
let g:plug_retries=2

" 按条件加载插件
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction
" examples:
" Plug 'benekastah/neomake', Cond(has('nvim'))
" Plug 'benekastah/neomake', Cond(has('nvim'), { 'on': 'Neomake' })

call plug#begin(get(g:, 'bundle_home', '~/.vim/plugged'))

"----------------------------------------------------------------------
" 基础配置
"----------------------------------------------------------------------
"--------------------------------
" clean hidden buffer
"--------------------------------
Plug 'Asheq/close-buffers.vim'


"--------------------------------
" tags
"--------------------------------
Plug 'ludovicchabant/vim-gutentags'
" Plug 'skywind3000/gutentags_plus'
let g:gutentags_cache_dir = expand('~/.cache/tags')
let g:gutentags_ctags_exclude=['.git', 'node_modules', 'log', 'db', '*.test.*', '*.spec.*', '__tests__']
let g:gutentags_exclude_project_root=['/usr/local', '/opt/homebrew', '/home/linuxbrew/.linuxbrew', '/home/ding/github/v8', '/home/ding/github/alacritty']

"--------------------------------
" 模糊搜索
"--------------------------------
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf

nnoremap <c-i> :GFiles<cr>
nnoremap <c-a-f> :Rg 
nnoremap <space>fa :Files<cr>
nnoremap <space>fh :History<cr>
nnoremap <space>fb :Buffers<cr>
nnoremap <space>fm :Commits<cr>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

"----------------------------------------------------------------------
" 辅助操作
"----------------------------------------------------------------------
"--------------------------------
" 括号补全
"--------------------------------
Plug 'jiangmiao/auto-pairs'
" let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsMapCh=0

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

"----------------------------------------------------------------------
" 智能补全
"----------------------------------------------------------------------
"--------------------------------
" coc插件系统
"--------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}

let g:coc_config_home = "~/github/b2ns/dotfiles/Vim/coc/"

let g:coc_global_extensions = [
      \ "coc-css",
      \ "coc-emmet",
      \ "coc-emoji",
      \ "coc-html",
      \ "coc-html-css-support",
      \ "coc-json",
      \ "coc-marketplace",
      \ "coc-prettier",
      \ "coc-sh",
      \ "coc-tsserver",
      \ "coc-vimlsp",
      \ "coc-snippets",
      \ "coc-explorer",
      \ "coc-highlight",
      \ "coc-floaterm",
      \ "coc-dictionary",
      \ "coc-tag",
      \ "coc-word",
      \]

" coc-explorer
nnoremap <silent> <space>n <Cmd>CocCommand explorer --quit-on-open --position left --width 50<CR>

" coc-css
autocmd FileType scss setl iskeyword+=@-@"

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

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

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

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

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

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
nnoremap <silent><nowait> <space>lm :<C-u>ALEPopulateQuickfix<cr>

" nmap <c-a-i> <Plug>(coc-format)
" nmap <c-a-o> :<c-u>Format<cr>
nmap mm :<c-u>Format<cr>
nmap <c-a-o> :<c-u>ORI<cr>
nmap <c-a-m> :CocCommand 
nmap <c-a-c> :<c-u>CocConfig<cr>
nmap <c-a-r> :CocSearch 

nmap ma <Plug>(coc-codeaction)
vmap ma  <Plug>(coc-codeaction-selected)
nmap mL  <Plug>(coc-codelens-action)
nmap mf <Plug>(coc-fix-current)
nmap mr <Plug>(coc-rename)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> gh :call ShowDocumentation()<CR>
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
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

"----------------------------------------------------------------------
" 类型扩展和语法高亮
"----------------------------------------------------------------------
"--------------------------------
" nvim的语法高亮
"--------------------------------
Plug 'nvim-treesitter/nvim-treesitter', Cond(has('nvim') && !g:var_is_win, {'do': ':TSUpdate'})

" 语法高亮优化
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

"----------------------------------------------------------------------
" 语法检查
"----------------------------------------------------------------------
"--------------------------------
" ALE
"--------------------------------
Plug 'dense-analysis/ale'
let g:ale_disable_lsp = 1
let g:ale_set_highlights = 0
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_insert_leave = 0
" let g:ale_lint_on_enter = 0
" let g:ale_lint_on_save = 0

let g:ale_linter_aliases = {'vue': ['vue', 'javascript']}
let g:ale_linters = {
      \ 'vue': ['eslint', 'vls'],
      \ 'asm': ['nasm'],
      \ }
let g:ale_fixers = {
      \ 'javascript': ['eslint'],
      \ 'typescript': ['eslint'],
      \ 'sh': ['shfmt'],
      \ 'vue': ['eslint']
      \ }
let g:ale_sh_shfmt_options="-ci" . " -i " . g:var_shiftwidth

nmap ml <Plug>(ale_lint)
nmap mF <Plug>(ale_fix)
nmap mp <Plug>(ale_previous)
nmap mn <Plug>(ale_next)


"----------------------------------------------------------------------
" 界面主题
"----------------------------------------------------------------------
"--------------------------------
" 主题配色
"--------------------------------
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'joshdick/onedark.vim'

nmap <silent> <f3> :call ToggleBackground()<cr>
call g:UTILBindkey('nmap <silent>', '<c-f3>', ":call ChangeColorscheme('next')<cr>")
call g:UTILBindkey('nmap <silent>', '<s-f3>', ":call ChangeColorscheme('pre')<cr>")

function ToggleBackground()
  let colorscheme=g:UTILGetColorscheme()
  let background=g:UTILToggleBackground()
  if !empty(background)
    call g:UTILLocalStorageSet('background', background)
    call g:UTILEchoAsync(colorscheme . ': ' . background)
  endif
endfunction

function ChangeColorscheme(nextOrPre)
  let colorscheme=""
  let colorscheme=g:UTILSwithColorscheme(a:nextOrPre)

  if !empty(colorscheme)
    call g:UTILLocalStorageSet('colorscheme', colorscheme)
    call g:UTILEchoAsync(colorscheme . ': ' . &background)
  endif
endfunction

"--------------------------------
" 状态栏
"--------------------------------
Plug 'vim-airline/vim-airline'

let g:airline_powerline_fonts = 1
let g:airline_exclude_preview = 1
let g:airline_highlighting_cache = 1
let g:airline_focuslost_inactive = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_stl_path_style = 'short'
let g:airline_section_c_only_filename = 1

"--------------------------------
" 缩进标识
"--------------------------------
Plug 'yggdroot/indentline'

let g:indentLine_char_list=['|', '¦', '┆', '┊']
autocmd FileType json,markdown let g:indentLine_setConceal=0
let g:indentLine_fileTypeExclude=['coc-explorer']

"----------------------------------------------------------------------
" Git集成
"----------------------------------------------------------------------

" 定义一个 DiffOrig 命令用于查看文件改动
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

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
" 终端
"--------------------------------
Plug 'voldikss/vim-floaterm'
if g:var_is_win
  let g:floaterm_shell="sh.exe"
endif
" let g:floaterm_wintype='vsplit'
" let g:floaterm_position='bottomright'
let g:floaterm_width=0.9
let g:floaterm_height=0.9
let g:floaterm_borderchars='-│-│┌┐┘└'
let g:floaterm_opener='tabe'
let g:floaterm_keymap_toggle = '<f4>'
nnoremap <silent> <c-a-t> :FloatermNew<CR>
tnoremap <silent> <c-a-t> <C-\><C-n>:FloatermNew<CR>

call g:UTILBindkey('nnoremap <silent>', '<c-f4>', ":FloatermNext<cr>")
call g:UTILBindkey('tnoremap <silent>', '<c-f4>', ":FloatermNext<cr>")
call g:UTILBindkey('nnoremap <silent>', '<s-f4>', ":FloatermPrev<cr>")
call g:UTILBindkey('tnoremap <silent>', '<s-f4>', ":FloatermPrev<cr>")

autocmd VimLeavePre * FloatermKill!

"----------------------------------------------------------------------
" 结束插件安装
"----------------------------------------------------------------------
call plug#end()

"--------------------------------
" lua类插件配置
"--------------------------------
if has('nvim') && !g:var_is_win
  lua << EOF
  require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
  ensure_installed = { "javascript", "typescript", "tsx","vim", "lua" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  indent = {
    enable = false
  },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "html", "css", "markdown" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
endif
