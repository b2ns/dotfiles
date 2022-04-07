#!/usr/bin/env bash
set -euo | IFS=$'\n\t'

function abspath() {
  echo "$(cd "$(dirname "$1")" && pwd)"
}

doClean="$1"
root=$(abspath "$0")
home=$HOME

configFiles=(
  \ "shell/.bash_config"
  \ "shell/.zsh_config"
  \ "prettier/.prettierrc.js"
  \ "editorconfig/.editorconfig"
  \ "eslint/.eslintrc.js"
  \ "stylelint/.stylelintrc.js"
  \ "typescript/tsconfig.json"
  \ "Vim/.vimrc"
  \ "Vim/AsyncTasks/.tasks"
  \ "Vim/AsyncTasks/.task.sh"
  \ "Vim/Vimspector/.vimspector.json"
)

# make symbolic link to home root
for file in ${configFiles[@]}; do
  pathname="$root/$file"
  filename=$(basename "$file")
  homeFilename="$home/$filename"

  if [[ $doClean != "uninstall" ]]; then
    ln -svf "$pathname" "$homeFilename"
  else
    rm -vf "$homeFilename"
    echo remove: $homeFilename
  fi
done
