"======================================================================
"
" 显示样式设置
"
"======================================================================


"----------------------------------------------------------------------
" 显示设置
"----------------------------------------------------------------------

" 总是显示行号
set number

" 关闭自动换行
" set nowrap

" 显示光标位置
set ruler

" 高亮光标所在行
" set cursorline
" 插入模式时取消高亮
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

" 禁止光标闪烁
"set gcr=a:block-blinkon0

" 隐藏可隐藏的文本
set concealcursor="nc"

" 显示匹配的括号
set showmatch

" 显示括号匹配的时间
set matchtime=2

" 显示最后一行
set display=lastline

" 总是显示侧边栏（用于显示 mark/gitdiff/诊断信息）
set signcolumn=yes

" 总是显示标签栏
set showtabline=1

" 允许下方显示目录
set wildmenu
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too

" 设置显示制表符等隐藏字符
set list

" 设置分隔符可视
set listchars=tab:›\ ,trail:•,extends:>,nbsp:.,precedes:<

" 右下角显示命令
set showcmd

" 插入模式在状态栏下面显示 -- INSERT --，
" 先注释掉，默认已经为真了，如果这里再设置一遍会影响 echodoc 插件
" set showmode

" 水平切割窗口时，默认在右边显示新窗口
set splitright

" 禁止显示滚动条
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

" 禁止显示菜单和工具条
set guioptions-=m
set guioptions-=T

" 默认启动窗口最大化
if has("gui_running")
  set lines=999 columns=999
" else
  " if exists("+lines")
    " set lines=30
  " endif
  " if exists("+columns")
    " set columns=100
  " endif
endif


"----------------------------------------------------------------------
" 颜色主题：色彩文件位于 colors 目录中
"----------------------------------------------------------------------

if (has("termguicolors"))
  set termguicolors
endif

" 允许 256 色
set t_Co=256

" 启动后设置一次主题和背景
call g:UTILSetColorscheme(g:var_colorscheme)
if g:var_enable_background_change_on_sunset
  call g:UTILSetBackgroundOnTime(g:var_sunrise_time, g:var_sunset_time)
else
  call g:UTILSetBackground(g:var_background)
endif

"----------------------------------------------------------------------
" 字体
"----------------------------------------------------------------------
let &guifont=g:UTILLocalStorageGet('font', g:var_guifont)

call g:UTILBindkey('nmap', '<c-f2>', ":call ChangeFontSize('bigger')<cr>")
call g:UTILBindkey('nmap', '<s-f2>', ":call ChangeFontSize('smaller')<cr>")

function ChangeFontSize(biggerOrSmaller = 'bigger') abort
  let operator = '+'
  if a:biggerOrSmaller == 'smaller'
    let operator = '-'
  endif
  let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)' . operator . '1', '')
  call UTILLocalStorageSet('font', &guifont)
  call g:UTILEchoAsync('guifont: ' . &guifont)
endfunction

"----------------------------------------------------------------------
" 状态栏设置
"----------------------------------------------------------------------
" 总是显示状态栏
set laststatus=2

set statusline=                                 " 清空状态了
set statusline+=\ %F                            " 文件名
set statusline+=\ [%1*%M%*%n%R%H]               " buffer 编号和状态
set statusline+=%=                              " 向右对齐
set statusline+=\ %y                            " 文件类型

" 最右边显示文件编码和行号等信息，并且固定在一个 group 中，优先占位
set statusline+=\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %v:%l/%L%)

" 错误格式
set errorformat+=[%f:%l]\ ->\ %m,[%f:%l]:%m


"----------------------------------------------------------------------
" 更改样式
"----------------------------------------------------------------------

" 更清晰的错误标注：默认一片红色背景，语法高亮都被搞没了
" 只显示红色或者蓝色下划线或者波浪线
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! clear SpellLocal
if has('gui_running')
  hi! SpellBad gui=undercurl guisp=red
  hi! SpellCap gui=undercurl guisp=blue
  hi! SpellRare gui=undercurl guisp=magenta
  hi! SpellRare gui=undercurl guisp=cyan
else
  hi! SpellBad term=standout ctermfg=1 term=underline cterm=underline
  hi! SpellCap term=underline cterm=underline
  hi! SpellRare term=underline cterm=underline
  hi! SpellLocal term=underline cterm=underline
endif

" 去掉 sign column 的白色背景
hi! SignColumn guibg=NONE ctermbg=NONE

" 修改行号为浅灰色，默认主题的黄色行号很难看，换主题可以仿照修改
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE 
      \ gui=NONE guifg=DarkGrey guibg=NONE


"----------------------------------------------------------------------
" quickfix 设置，隐藏行号
"----------------------------------------------------------------------
augroup VimInitStyle
  au!
  au FileType qf setlocal nonumber
augroup END


"----------------------------------------------------------------------
" 标签栏文字风格：默认为零，GUI 模式下空间大，按风格 3显示
" 0: filename.txt
" 2: 1 - filename.txt
" 3: [1] filename.txt
"----------------------------------------------------------------------
if has('gui_running')
  let g:config_vim_tab_style = 3
endif


"----------------------------------------------------------------------
" 终端下的 tabline
"----------------------------------------------------------------------
function! Vim_NeatTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{Vim_NeatTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XX'
  endif

  return s
endfunc


"----------------------------------------------------------------------
" 需要显示到标签上的文件名
"----------------------------------------------------------------------
function! Vim_NeatBuffer(bufnr, fullname)
  let l:name = bufname(a:bufnr)
  if getbufvar(a:bufnr, '&modifiable')
    if l:name == ''
      return '[No Name]'
    else
      if a:fullname
        return fnamemodify(l:name, ':p')
      else
        let aname = fnamemodify(l:name, ':p')
        let sname = fnamemodify(aname, ':t')
        if sname == ''
          let test = fnamemodify(aname, ':h:t')
          if test != ''
            return '<'. test . '>'
          endif
        endif
        return sname
      endif
    endif
  else
    let l:buftype = getbufvar(a:bufnr, '&buftype')
    if l:buftype == 'quickfix'
      return '[Quickfix]'
    elseif l:name != ''
      if a:fullname
        return '-'.fnamemodify(l:name, ':p')
      else
        return '-'.fnamemodify(l:name, ':t')
      endif
    else
    endif
    return '[No Name]'
  endif
endfunc


"----------------------------------------------------------------------
" 标签栏文字，使用 [1] filename 的模式
"----------------------------------------------------------------------
function! Vim_NeatTabLabel(n)
  let l:buflist = tabpagebuflist(a:n)
  let l:winnr = tabpagewinnr(a:n)
  let l:bufnr = l:buflist[l:winnr - 1]
  let l:fname = Vim_NeatBuffer(l:bufnr, 0)
  let l:num = a:n
  let style = get(g:, 'config_vim_tab_style', 0)
  if style == 0
    return l:fname
  elseif style == 1
    return "[".l:num."] ".l:fname
  elseif style == 2
    return "".l:num." - ".l:fname
  endif
  if getbufvar(l:bufnr, '&modified')
    return "[".l:num."] ".l:fname." +"
  endif
  return "[".l:num."] ".l:fname
endfunc


"----------------------------------------------------------------------
" GUI 下的标签文字，使用 [1] filename 的模式
"----------------------------------------------------------------------
function! Vim_NeatGuiTabLabel()
  let l:num = v:lnum
  let l:buflist = tabpagebuflist(l:num)
  let l:winnr = tabpagewinnr(l:num)
  let l:bufnr = l:buflist[l:winnr - 1]
  let l:fname = Vim_NeatBuffer(l:bufnr, 0)
  let style = get(g:, 'config_vim_tab_style', 0)
  if style == 0
    return l:fname
  elseif style == 1
    return "[".l:num."] ".l:fname
  elseif style == 2
    return "".l:num." - ".l:fname
  endif
  if getbufvar(l:bufnr, '&modified')
    return "[".l:num."] ".l:fname." +"
  endif
  return "[".l:num."] ".l:fname
endfunc



"----------------------------------------------------------------------
" 设置 GUI 标签的 tips: 显示当前标签有哪些窗口
"----------------------------------------------------------------------
function! Vim_NeatGuiTabTip()
  let tip = ''
  let bufnrlist = tabpagebuflist(v:lnum)
  for bufnr in bufnrlist
    " separate buffer entries
    if tip != ''
      let tip .= " \n"
    endif
    " Add name of buffer
    let name = Vim_NeatBuffer(bufnr, 1)
    let tip .= name
    " add modified/modifiable flags
    if getbufvar(bufnr, "&modified")
      let tip .= ' [+]'
    endif
    if getbufvar(bufnr, "&modifiable")==0
      let tip .= ' [-]'
    endif
  endfor
  return tip
endfunc


"----------------------------------------------------------------------
" 标签栏最终设置
"----------------------------------------------------------------------
set tabline=%!Vim_NeatTabLine()
set guitablabel=%{Vim_NeatGuiTabLabel()}
set guitabtooltip=%{Vim_NeatGuiTabTip()}

"----------------------------------------------------------------------
" 终端下光标切换形态和闪烁
"----------------------------------------------------------------------
if has('nvim')
  set guicursor+=a:blinkwait700-blinkon400-blinkoff250
elseif has('terminal') && !has('gui_running')
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
  au InsertEnter,InsertChange *
        \ if v:insertmode == 'i' | 
        \   silent execute '!echo -ne "\e[5 q"' | redraw! |
        \ elseif v:insertmode == 'r' |
        \   silent execute '!echo -ne "\e[3 q"' | redraw! |
        \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif
