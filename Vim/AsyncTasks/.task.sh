#!/usr/bin/env bash
set -euo | IFS=$'\n\t'

filetype="$1"
taskName="$2"
build_dir="$HOME/.build"
tmp_dir="/tmp"

################################################################################
# java
################################################################################
rebuildWhenRun="$3"
java_classpath="$build_dir/java/classpath"
java_jar="$build_dir/java/jar"

function getJavaPkgName() {
  match="$(grep -oE "^[ ]*package [^;]+;" $VIM_FILEPATH)"
  match=${match##*package }
  match=${match%%;*}
  echo $match
}

function getJavaClassName() {
  pkgName=$(getJavaPkgName)
  if [[ -n "$pkgName" ]]; then
    echo "$pkgName.$VIM_FILENOEXT"
  else
    echo "$VIM_FILENOEXT"
  fi
}

function buildJava() {
  javac -d "$java_classpath" "$VIM_FILEPATH"
}

function buildJavaWithJar() {
  javac -d "$java_classpath" "$VIM_FILEPATH" && jar -cvf "$java_jar/All.jar" -C "$java_classpath" .
}

function runJava() {
  className=$(getJavaClassName)
  if [[ $rebuildWhenRun == "y" ]]; then
    buildJava && java "$className"
  else
    classFile=${className//./\/}
    classFile="$java_classpath/$classFile.class"
    if [[ -e "$classFile" ]]; then
      rm -f $classFile
    fi
    java "$VIM_FILEPATH"
  fi
}

function testJava() {
  className=$(getJavaClassName)
  buildJava && java org.junit.runner.JUnitCore "$className"
}

################################################################################
# ts
################################################################################
ts_dir="$tmp_dir/ts"

function buildTs() {
  tsc --target esnext --module commonjs --jsx react --outDir "$ts_dir" "$VIM_FILEPATH"
}

function runTs() {
  buildTs
  node "$ts_dir/$VIM_FILENOEXT.js"
}

################################################################################
# c, c++
################################################################################
c_dir="$tmp_dir"

function buildC() {
  gcc -O2 -Wall "$VIM_FILEPATH" -o "$c_dir/c-$VIM_FILENOEXT" -lstdc++ -lm -msse3
}

function runC() {
  buildC
  "$c_dir/c-$VIM_FILENOEXT"
}


################################################################################
# entry
################################################################################
case "$filetype" in
  java)
    case $taskName in
      build)
        buildJavaWithJar
        ;;
      run)
        runJava
        ;;
      test)
        testJava
        ;;
    esac
    ;;

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
    echo filetype:$filetype not defined in task
    ;;
esac
