" Title: vim-syncr
" Description: Upload/download/delete files and directories with rsync
" Usage: :VsUpload, VsDownload and :VsRemove
"        Mapped to
"        <leader>vsu (vim-syncr upload)
"        <leader>vsd (vim-syncr download)
"        <leader>vsr (vim-syncr remove)
"        See README for more
" Note: a fork from https://github.com/s10g/vim-syncr
" License: MIT

function! VS_GetConf()
  let conf = {}

  let l_configpath = expand('%:p:h')
  let l_configfile = l_configpath . '/.syncr'
  let l_foundconfig = ''
  if filereadable(l_configfile)
    let l_foundconfig = l_configfile
  else
    while !filereadable(l_configfile)
      let slashindex = strridx(l_configpath, '/')
      if slashindex >= 0
        let l_configpath = l_configpath[0:slashindex]
        let l_configfile = l_configpath . '.syncr'
        let l_configpath = l_configpath[0:slashindex-1]
        if filereadable(l_configfile)
          let l_foundconfig = l_configfile
          break
        endif
        if slashindex == 0 && !filereadable(l_configfile)
          break
        endif
      else
        break
      endif
    endwhile
  endif

  if strlen(l_foundconfig) > 0
    let options = readfile(l_foundconfig)
    for i in options
      let vname = substitute(i[0:stridx(i, ' ')], '^\s*\(.\{-}\)\s*$', '\1', '')
      let vvalue = escape(substitute(i[stridx(i, ' '):], '^\s*\(.\{-}\)\s*$', '\1', ''), "%#!")
      let conf[vname] = vvalue
    endfor
  endif

  return conf
endfunction


function! VS_UploadFiles()
  let conf = VS_GetConf()

  if has_key(conf, 'remote_host')
        let cmd = "rsync -avze ssh " . conf['project_path'] . " " . conf['remote_user'] . "@" . conf['remote_host'] . ":" . conf['remote_path'] . " --exclude='.syncr'" . " --exclude={" . conf['exclude'] . "}"
        execute '!' . cmd
  else
    echo 'Could not locate a .syncr configuration file. Aborting...'
  endif
endfunction


function! VS_RemoveFiles()
  let conf = VS_GetConf()

  if has_key(conf, 'remote_host')
        let cmd = "rsync -avze ssh " . conf['project_path'] . " " . conf['remote_user'] . "@" . conf['remote_host'] . ":" . conf['remote_path'] . " --delete" . " --exclude='.syncr'" . " --exclude={" . conf['exclude'] . "}"
        execute '!' . cmd
  else
    echo 'Could not locate a .syncr configuration file. Aborting...'
  endif
endfunction


function! VS_DownloadFiles()
  let conf = VS_GetConf()

  if has_key(conf, 'remote_host')
        let cmd = "rsync -avze ssh " . conf['remote_user'] . "@" . conf['remote_host'] . ":" . conf['remote_path']  . " " . conf['project_path'] . " --delete" . " --exclude='.syncr'" . " --exclude={" . conf['exclude'] . "}"
        execute '!' . cmd
  else
    echo 'Could not locate a .syncr configuration file. Aborting...'
  endif
endfunction

command! VsUpload call VS_UploadFiles()
command! VsRemove call VS_RemoveFiles()
command! VsDownload call VS_DownloadFiles()

nmap <leader>vsu :VsUpload<Esc>
nmap <leader>vsr :VsRemove<Esc>
nmap <leader>vsd :VsDownload<Esc>
