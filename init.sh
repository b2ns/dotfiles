#!/usr/bin/env bash
set -euo | IFS=$'\n\t'
source libshell

__dirname="$(Path_dirname "${BASH_SOURCE[0]}")"

################################################
# main logic
################################################
declare -gA configFiles=(
  ["terminal/.alacritty.yml"]=""
  ["shell/.bash_config"]=""
  ["shell/.zsh_config"]=""
  ["prettier/.prettierrc.js"]=""
  ["editorconfig/.editorconfig"]=""
  ["eslint/.eslintrc.js"]=""
  ["stylelint/.stylelintrc.js"]=""
  ["typescript/tsconfig.json"]=""
  ["Vim/.vimrc"]=""
  ["Vim/AsyncTasks/.tasks"]=""
  ["Vim/AsyncTasks/.task.sh"]=""
  ["Vim/Vimspector/.vimspector.json"]=""
  ["./Vim/init.vim"]="$HOME/.config/nvim/init.vim"

  # prefix with [copy]: to copy file rather than link
  # ["[copy]:./Vim/init.vim"]=""
)

install() {
  local file=""
  local control=""
  local key=""
  for key in "${!configFiles[@]}"; do
    control="$(String_stripEnd "$key" "]:*" 1)"
    file="$(String_stripStart "$key" "*]:")"

    local src=""
    src="$(Path_resolve "$__dirname" "$file")"

    local dest="${configFiles[$key]}"

    if String_isEmpty "$dest"; then
      dest="$HOME/$(Path_basename "$file")"
    else
      local destDir=""
      destDir="$(Path_dirname "$dest")"
      if ! File_isDir "$destDir"; then
        mkdir -p "$destDir"
      fi
    fi

    if File_isExist "$dest"; then
      IO_warn "Already exists: $dest"
    else
      if String_includes "$control" "copy"; then
        IO_info "Copy $file to $dest"
        cp -r "$src" "$dest"
      else
        IO_info "Link $file to $dest"
        ln -s "$src" "$dest"
      fi
    fi
  done

  IO_success "Done!"
}

uninstall() {
  local file=""
  local key=""
  for key in "${!configFiles[@]}"; do
    file="$(String_stripStart "$key" "*]:")"

    local dest="${configFiles[$key]}"

    if String_isEmpty "$dest"; then
      dest="$HOME/$(Path_basename "$file")"
    fi

    if File_isExist "$dest"; then
      if File_isSymlink "$dest"; then
        IO_info "Removing link: $dest"
        rm "$dest"
      else
        IO_warn "$dest is not a link, delete manually"
      fi
    else
      IO_warn "Not found: $dest"
    fi
  done

  IO_success "Done!"
}

################################################
# handle arguments
################################################
Args_define "-i --install" "Install the config"
Args_define "-u --uninstall" "Uninstall the config"
Args_define "-h --help" "Show help"

Args_parse "$@"

if Args_has "-i"; then
  install
  exit 0
fi

if Args_has "-u"; then
  uninstall
  exit 0
fi

if Args_has "-h" || (($# == 0)); then
  Args_help
  exit 0
fi
