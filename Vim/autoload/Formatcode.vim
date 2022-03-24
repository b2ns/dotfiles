""""""""""""""""""""""""""""""""""""""""
" utils
""""""""""""""""""""""""""""""""""""""""
function! FormatcodeReplace(lines, startSelection, endSelection) abort
  " store view
  let l:winview = winsaveview()
  let l:newBuffer = FormatcodeCreateBufferFromUpdatedLines(a:lines, a:startSelection, a:endSelection)

  " we should not replace contents if the newBuffer is empty
  if empty(l:newBuffer)
    return
  endif

  " https://vim.fandom.com/wiki/Restore_the_cursor_position_after_undoing_text_change_made_by_a_script
  " create a fake change entry and merge with undo stack prior to do formating
  execute "normal! i "
  execute "normal! a\<BS>"
  try | silent undojoin | catch | endtry

  " delete all lines on the current buffer
  silent! execute 'lockmarks %delete _'

  " replace all lines from the current buffer with output from Formatcode
  let l:idx = 0
  for l:line in l:newBuffer
    silent! lockmarks call append(l:idx, l:line)
    let l:idx += 1
  endfor

  " delete trailing newline introduced by the above append procedure
  silent! lockmarks execute '$delete _'

  " Restore view
  call winrestview(l:winview)

endfunction

function! FormatcodeReplaceAndSave(lines, startSelection, endSelection) abort
  call FormatcodeReplace(a:lines, a:startSelection, a:endSelection)
  noautocmd write
endfunction

" Returns 1 if content has changed
function! FormatcodeWillUpdatedLinesChangeBuffer(lines, start, end) abort
  return getbufline(bufnr('%'), 1, line('$')) == FormatcodeCreateBufferFromUpdatedLines(a:lines, a:start, a:end) ? 0 : 1
endfunction

" Returns a new buffer with lines replacing start and end of the contents of the current buffer
function! FormatcodeCreateBufferFromUpdatedLines(lines, start, end) abort
  return getbufline(bufnr('%'), 1, a:start - 1) + a:lines + getbufline(bufnr('%'), a:end + 1, '$')
endfunction

" Adapted from https://github.com/farazdagi/vim-go-ide
function! s:getCharPosition(line, col) abort
  if &encoding !=# 'utf-8'
    " On utf-8 enconding we can't just use bytes so we need to make sure we can count the
    " characters, we do that by adding the text into a temporary buffer and counting the chars
    let l:buf = a:line == 1 ? '' : (join(getline(1, a:line - 1), "\n") . "\n")
    let l:buf .= a:col == 1 ? '' : getline('.')[:a:col - 2]
    return len(iconv(l:buf, &encoding, 'utf-8'))
  endif
  " On non utf-8 the line byte should match the character
  return line2byte(a:line) + (a:col - 2)
endfun

" Returns [start, end] byte range when on visual mode
function! FormatcodeGetCharRange(startSelection, endSelection) abort
  let l:range = []
  call add(l:range, s:getCharPosition(a:startSelection, col("'<")))
  call add(l:range, s:getCharPosition(a:endSelection, col("'>")))
  return l:range
endfunction

let s:PREFIX_MSG = 'Formatcode: '
let s:ERRORS = {
      \ 'EXECUTABLE_NOT_FOUND_ERROR': 'no Formatcode executable installation found',
      \ 'PARSING_ERROR': 'failed to parse buffer',
      \ }
let s:DEFAULT_ERROR = get(s:, 'PARSING_ERROR')

function! FormatcodeErrorLog(...) abort
  let l:error = a:0 > 0 ? a:1 : s:DEFAULT_ERROR
  let l:msg = a:0 > 1 ? ': ' . a:2 : ''
  echohl WarningMsg | echom s:PREFIX_MSG . get(s:ERRORS, l:error, s:DEFAULT_ERROR) . l:msg | echohl NONE
endfunction

""""""""""""""""""""""""""""""""""""""""
" async job runner
""""""""""""""""""""""""""""""""""""""""
let s:formatcode_job_running = 0

function! FormatcodeJobRun(cmd, startSelection, endSelection) abort
  if s:formatcode_job_running == 1
    return
  endif
  let s:formatcode_job_running = 1

  let l:bufferName = bufname('%')

  let l:job = job_start([&shell, &shellcmdflag, a:cmd], {
        \ 'out_io': 'buffer',
        \ 'err_cb': {channel, msg -> s:onError(msg)},
        \ 'close_cb': {channel -> s:onClose(channel, a:startSelection, a:endSelection, l:bufferName)}})

  let l:stdin = job_getchannel(l:job)

  call ch_sendraw(l:stdin, join(getbufline(bufnr(l:bufferName), a:startSelection, a:endSelection), "\n"))
  call ch_close_in(l:stdin)
endfunction

function! s:onError(msg) abort
  call FormatcodeErrorLog('PARSING_ERROR', a:msg)
  let s:formatcode_job_running = 0
endfunction

function! s:onClose(channel, startSelection, endSelection, bufferName) abort
  let l:out = []
  let l:currentBufferName = bufname('%')
  let l:isInsideAnotherBuffer = a:bufferName != l:currentBufferName ? 1 : 0

  let l:buff = ch_getbufnr(a:channel, 'out')
  let l:out = getbufline(l:buff, 2, '$')
  execute 'bd!' . l:buff

  " we have no Formatcode output so lets exit
  if len(l:out) == 0 | return | endif

  " nothing to update
  if (FormatcodeWillUpdatedLinesChangeBuffer(l:out, a:startSelection, a:endSelection) == 0)
    let s:formatcode_job_running = 0
    redraw!
    return
  endif

  " This is required due to race condition when user quickly switch buffers while the async
  " cli has not finished running, vim 8.0.1039 has introduced setbufline() which can be used
  " to fix this issue in a cleaner way, however since we still need to support older vim versions
  " we will apply a more generic solution
  if (l:isInsideAnotherBuffer)
    " Do no try to format buffers that have been closed
    if (bufloaded(str2nr(a:bufferName)))
      try
        silent exec 'sp '. escape(bufname(bufnr(a:bufferName)), ' \')
        call FormatcodeReplaceAndSave(l:out, a:startSelection, a:endSelection)
      catch
        call FormatcodeErrorLog('PARSING_ERROR', a:bufferName)
      finally
        " we should then hide this buffer again
        if a:bufferName == bufname('%')
          silent hide
        endif
      endtry
    endif
  else
    call FormatcodeReplaceAndSave(l:out, a:startSelection, a:endSelection)
  endif
  let s:formatcode_job_running = 0
endfunction

""""""""""""""""""""""""""""""""""""""""
" main
""""""""""""""""""""""""""""""""""""""""
let s:isLegacyVim = v:version < 800
let s:isAsyncVim = !s:isLegacyVim && exists('*job_start')

function! Formatcode#Run(cmd) abort
  call FormatcodeRunnerRun(a:cmd, 1, line('$'), 1)
endfunction

function! FormatcodeRunnerRun(cmd, startSelection, endSelection, async) abort
  if a:async && (s:isAsyncVim)
    call s:asyncFormat(a:cmd, a:startSelection, a:endSelection)
  else
    call s:format(a:cmd, a:startSelection, a:endSelection)
  endif
endfunction

function! s:asyncFormat(cmd, startSelection, endSelection) abort
  if !s:isAsyncVim
    call s:format(a:cmd, a:startSelection, a:endSelection)
  endif

  " required for Windows support on async operations 
  let l:cmd = a:cmd
  if has('win32') || has('win64')
    let l:cmd = 'cmd.exe /c ' . a:cmd
  endif

  if s:isAsyncVim
    call FormatcodeJobRun(l:cmd, a:startSelection, a:endSelection)
  endif
endfunction

function! s:format(cmd, startSelection, endSelection) abort
  let l:bufferLinesList = getbufline(bufnr('%'), a:startSelection, a:endSelection)

  " vim 7 does not have support for passing a list to system()
  let l:bufferLines = s:isLegacyVim ? join(l:bufferLinesList, "\n") : l:bufferLinesList

  " TODO
  " since we are using two different types for system, maybe we should move it to utils shims
  let l:out = split(system(a:cmd, l:bufferLines), '\n')

  " check system exit code
  if v:shell_error
    call FormatcodeErrorLog('PARSING_ERROR')
    return
  endif

  " TODO
  " doing 0 checks seems weird can we do this bellow differently ?
  if (FormatcodeWillUpdatedLinesChangeBuffer(l:out, a:startSelection, a:endSelection) == 0)
    return
  endif

  call FormatcodeReplace(l:out, a:startSelection, a:endSelection)
endfunction
