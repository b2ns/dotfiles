#!/usr/bin/env bash
set -euo | IFS=$'\n\t'

filetype="$1"
taskName="$2"
build_dir="$HOME/.build"
tmp_dir="/tmp"

################################################################################
# ts
################################################################################
ts_dir="$tmp_dir/ts"

buildTs() {
  tsc --target esnext --module commonjs --jsx react --outDir "$ts_dir" "$VIM_FILEPATH"
}

runTs() {
  tsx "$VIM_FILEPATH" || {
    buildTs
    node "$ts_dir/$VIM_FILENOEXT.js"
  }
}

################################################################################
# c, c++
################################################################################
c_dir="$tmp_dir"

buildC() {
  gcc -O2 -Wall "$VIM_FILEPATH" -o "$c_dir/c-$VIM_FILENOEXT" -lstdc++ -lm -msse3
}

runC() {
  buildC
  "$c_dir/c-$VIM_FILENOEXT"
}


################################################################################
# entry
################################################################################
case "$filetype" in
  ts)
    case $taskName in
      build)
        buildTs
        ;;
      run)
        runTs
        ;;
      test)
        ;;
    esac
    ;;

  c)
    case $taskName in
      build)
        buildC
        ;;
      run)
        runC
        ;;
      test)
        ;;
    esac
    ;;

  *)
    echo filetype:"$filetype" not defined in task
    ;;
esac
