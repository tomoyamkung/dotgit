#!/bin/bash
set -eu

# ライブラリスクリプトを読み込む
. ${DOTGIT?"export DOTGIT=~/dotgit"}/bin/lib/dry_run.sh
. ${DOTGIT?"export DOTGIT=~/dotgit"}/bin/lib/is_installed.sh

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) は ~/.gitconfig を作成するスクリプトである。
  既に ~/.gitconfig が存在する場合は処理を終了する。

Usage:
  $(basename ${0}) [-h] [-x]

Options:
  -h print this
  -x dry-run モードで実行する
EOF
  exit 0
}

while getopts hx OPT
do
  case "$OPT" in
    h) usage ;;
    x) enable_dryrun ;;
    \?) usage ;;
  esac
done

# ~/.gitconfig が存在する場合は処理を終了する
[[ -f ~/.gitconfig ]] && exit 0

# [core] の editor を設定する
editor=vi  # デフォルトは Vi とする
is_installed vim && editor=vim  # Vim がインストールされている場合は Vim とする

# 各種設定を sed で置換して ~/.gitconfig を作成する
if [ ! -z ${dryrun} ]; then
  sed -e "s/_EDITOR_/${editor}/" ${DOTGIT}/etc/deploy/000_config/gitconfig
else
  sed -e "s/_EDITOR_/${editor}/" ${DOTGIT}/etc/deploy/000_config/gitconfig > ~/.gitconfig
fi

exit 0
