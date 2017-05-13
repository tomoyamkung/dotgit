#!/bin/bash -eu
set -eu

function usage() {
  cat <<EOF 1>&2
Description:
  コマンドがインストールされているかを確認する。
  コマンドの存在確認は type コマンドを使って行う。

Usage:
  $(basename ${0}) command_name

EOF
  exit 0
}

function is_installed() {
  type $1 > /dev/null 2>&1
  return $?
}
