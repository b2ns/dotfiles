"======================================================================
"
" 按键设置
"
"======================================================================


"----------------------------------------------------------------------
" free key to bind
" 1. function keys: <F3>-<F12>
" 2. normal mode: <C-h>, <C-j>, <C-k>, <C-n>, <C-p>
" 3. insert mode: <C-b>
" 4. visual mode: <C-h>, <C-j>, <C-k>, <C-n>, <C-p>, <C-r>, <C-t>, Q
" 5. command mode: <C-o>
" 6. begion with: <leader>, <space>, <alt>
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" 基础
"----------------------------------------------------------------------

" 修改<Leader>，默认为'\'
let mapleader=","

" 反向查找
noremap \ ,

" like C D in normal mode
nnoremap Y y$

" 保存
nnoremap <leader>w :w<cr>
nnoremap <leader>W :wa<cr>

" 退出
nnoremap <silent> <leader>q :q<cr>
nnoremap <silent> Q :qa<cr>

" 全选
nnoremap <c-a> ggVG

" 复制
vnoremap <c-c> "+y
nnoremap <c-c> :let @+=@"<cr>

" 剪切
vnoremap <c-x> "+x

" 粘贴
nnoremap <c-v> "+P
inoremap <c-v> <c-r>+
cnoremap <c-v> <c-r>"

" 整行上下移动
noremap <m-up> :.m--<cr>
noremap <m-down> :.m+<cr>

" 通用正则搜索
noremap / /\v
noremap ? ?\v

" 重复上次替换
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" 清空查找高亮
nnoremap <silent> <s-l> :nohlsearch<cr>

" 命令行历史
cnoremap <c-p> <up>
cnoremap <c-n> <down>

" 缩略词
" iabbrev dns domain name system

" 防止缩进时失去选择
xnoremap <  <gv
xnoremap >  >gv
"----------------------------------------------------------------------
" INSERT 模式下使用 EMACS 键位
"----------------------------------------------------------------------
inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <c-d> <del>
inoremap <c-_> <c-k>


"----------------------------------------------------------------------
" 设置 CTRL+HJKL 移动光标（INSERT 模式偶尔需要移动的方便些）
" 使用 SecureCRT/XShell 等终端软件需设置：Backspace sends delete
" 详见：http://www.skywind.me/blog/archives/2021
"----------------------------------------------------------------------
inoremap <C-h> <left>
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-l> <right>


"----------------------------------------------------------------------
" 命令模式的快速移动
"----------------------------------------------------------------------
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <c-d>
cnoremap <c-b> <left>
cnoremap <c-d> <del>
cnoremap <c-_> <c-k>


"----------------------------------------------------------------------
" ALT+N 切换 tab
"----------------------------------------------------------------------
noremap <silent><m-1> :tabn 1<cr>
noremap <silent><m-2> :tabn 2<cr>
noremap <silent><m-3> :tabn 3<cr>
noremap <silent><m-4> :tabn 4<cr>
noremap <silent><m-5> :tabn 5<cr>
noremap <silent><m-6> :tabn 6<cr>
noremap <silent><m-7> :tabn 7<cr>
noremap <silent><m-8> :tabn 8<cr>
noremap <silent><m-9> :tabn 9<cr>
noremap <silent><m-0> :tabn 10<cr>
inoremap <silent><m-1> <ESC>:tabn 1<cr>
inoremap <silent><m-2> <ESC>:tabn 2<cr>
inoremap <silent><m-3> <ESC>:tabn 3<cr>
inoremap <silent><m-4> <ESC>:tabn 4<cr>
inoremap <silent><m-5> <ESC>:tabn 5<cr>
inoremap <silent><m-6> <ESC>:tabn 6<cr>
inoremap <silent><m-7> <ESC>:tabn 7<cr>
inoremap <silent><m-8> <ESC>:tabn 8<cr>
inoremap <silent><m-9> <ESC>:tabn 9<cr>
inoremap <silent><m-0> <ESC>:tabn 10<cr>


" MacVim 允许 CMD+数字键快速切换标签
if has("gui_macvim")
  set macmeta
  noremap <silent><d-1> :tabn 1<cr>
  noremap <silent><d-2> :tabn 2<cr>
  noremap <silent><d-3> :tabn 3<cr>
  noremap <silent><d-4> :tabn 4<cr>
  noremap <silent><d-5> :tabn 5<cr>
  noremap <silent><d-6> :tabn 6<cr>
  noremap <silent><d-7> :tabn 7<cr>
  noremap <silent><d-8> :tabn 8<cr>
  noremap <silent><d-9> :tabn 9<cr>
  noremap <silent><d-0> :tabn 10<cr>
  inoremap <silent><d-1> <ESC>:tabn 1<cr>
  inoremap <silent><d-2> <ESC>:tabn 2<cr>
  inoremap <silent><d-3> <ESC>:tabn 3<cr>
  inoremap <silent><d-4> <ESC>:tabn 4<cr>
  inoremap <silent><d-5> <ESC>:tabn 5<cr>
  inoremap <silent><d-6> <ESC>:tabn 6<cr>
  inoremap <silent><d-7> <ESC>:tabn 7<cr>
  inoremap <silent><d-8> <ESC>:tabn 8<cr>
  inoremap <silent><d-9> <ESC>:tabn 9<cr>
  inoremap <silent><d-0> <ESC>:tabn 10<cr>
endif


"----------------------------------------------------------------------
" TAB：创建，关闭，上一个，下一个，左移，右移
" 其实还可以用原生的 CTRL+PageUp, CTRL+PageDown 来切换标签
"----------------------------------------------------------------------

noremap <silent> <leader>tc :tabnew<cr>
noremap <silent> <leader>to :tabonly<cr>
noremap <silent> <c-l> :tabnext<cr>
noremap <silent> <c-h> :tabprev<cr>


" 左移 tab
function! Tab_MoveLeft()
  let l:tabnr = tabpagenr() - 2
  if l:tabnr >= 0
    exec 'tabmove '.l:tabnr
  endif
endfunc

" 右移 tab
function! Tab_MoveRight()
  let l:tabnr = tabpagenr() + 1
  if l:tabnr <= tabpagenr('$')
    exec 'tabmove '.l:tabnr
  endif
endfunc

noremap <silent><c-left> :call Tab_MoveLeft()<cr>
noremap <silent><c-right> :call Tab_MoveRight()<cr>


"----------------------------------------------------------------------
" ALT 键移动增强
"----------------------------------------------------------------------

" Windows 禁用 ALT 操作菜单（使得 ALT 可以用到 Vim里）
set winaltkeys=no

"----------------------------------------------------------------------
" 窗口切换：ALT+SHIFT+hjkl
" 传统的 CTRL+hjkl 移动窗口不适用于 vim 8.1 的终端模式，CTRL+hjkl 在
" bash/zsh 及带文本界面的程序中都是重要键位需要保留，不能 tnoremap 的
"----------------------------------------------------------------------
noremap <m-H> <c-w>h
noremap <m-L> <c-w>l
noremap <m-J> <c-w>j
noremap <m-K> <c-w>k
inoremap <m-H> <esc><c-w>h
inoremap <m-L> <esc><c-w>l
inoremap <m-J> <esc><c-w>j
inoremap <m-K> <esc><c-w>k

if has('terminal') && exists(':terminal') == 2 && has('patch-8.1.1')
  " vim 8.1 支持 termwinkey ，不需要把 terminal 切换成 normal 模式
  " 设置 termwinkey 为 CTRL 加减号（GVIM），有些终端下是 CTRL+?
  " 后面四个键位是搭配 termwinkey 的，如果 termwinkey 更改，也要改
  set termwinkey=<c-_>
  tnoremap <m-H> <c-_>h
  tnoremap <m-L> <c-_>l
  tnoremap <m-J> <c-_>j
  tnoremap <m-K> <c-_>k
  tnoremap <m-q> <c-\><c-n>
elseif has('nvim')
  " neovim 没有 termwinkey 支持，必须把 terminal 切换回 normal 模式
  tnoremap <m-H> <c-\><c-n><c-w>h
  tnoremap <m-L> <c-\><c-n><c-w>l
  tnoremap <m-J> <c-\><c-n><c-w>j
  tnoremap <m-K> <c-\><c-n><c-w>k
  tnoremap <m-q> <c-\><c-n>
endif
