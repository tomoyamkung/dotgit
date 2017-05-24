#!/bin/bash
set -eu

# ライブラリスクリプトを読み込む
. ${DOTGIT?"export DOTGIT=~/dotgit"}/bin/lib/dry_run.sh
. ${DOTGIT?"export DOTGIT=~/dotgit"}/bin/lib/is_installed.sh

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) は ~/.gitconfig を作成するスクリプトである。
  既に ~/.gitconfig が存在する場合は処理を終了するが、 -f オプションを指定した場合は強制実行する。

Usage:
  $(basename ${0}) [-f] [-h] [-x]

Options:
  -f ~/.gitconfig が存在していても処理を継続する
  -h print this
  -x dry-run モードで実行する
EOF
  exit 0
}

force_execute=
while getopts fhx OPT
do
  case "$OPT" in
    f) force_execute=true ;;
    h) usage ;;
    x) enable_dryrun ;;
    \?) usage ;;
  esac
done

# -f オプションが指定された場合は ~/.gitconfig が存在しても処理を継続する
# -f オプションが指定されておらず、かつ、 ~/.gitconfig が存在する場合は処理を終了する
if [[ -z "$force_execute" ]] && [[ -f ~/.gitconfig ]]; then
  exit 0
fi

# [user] を設定する
# name, email の値を read コマンドを使って設定する
echo -n "user.name: "; read name
echo -n "user.email: "; read email

# [core] の editor を設定する
editor=vi  # デフォルトは Vi とする
is_installed vim && editor=vim  # Vim がインストールされている場合は Vim とする

# ~/.gitconfig が存在しており、かつ、"# dotgit" から始まる行があればそこから下の行を一時的に保管しておく
temp_file=/tmp/dotgit.gitconfig
if [[ -f ~/.gitconfig ]] && [[ $(grep -q "# dotgit" ~/.gitconfig; echo $?) == 0 ]]; then
  end_line=$(awk 'END{print NR}' ~/.gitconfig)
  start_line=$(grep -n "# dotgit" ~/.gitconfig | awk -F: '{print $1}')
  # 開始行と終了行が一致している場合は追加した設定がないので何もしない
  if [[ $start_line != $end_line ]]; then
    start_line=$(expr $start_line + 1)
	sed -n "${start_line},${end_line}p" ~/.gitconfig > "$temp_file"
  fi
fi

# 各種設定を sed で置換して ~/.gitconfig を作成する
if [ ! -z ${dryrun} ]; then
  sed -e "s/_NAME_/${name}/" -e "s/_EMAIL_/${email}/" -e "s/_EDITOR_/${editor}/" ${DOTGIT}/etc/deploy/000_config/gitconfig
  [[ -f "$temp_file" ]] && cat "$temp_file"
else
  sed -e "s/_NAME_/${name}/" -e "s/_EMAIL_/${email}/" -e "s/_EDITOR_/${editor}/" ${DOTGIT}/etc/deploy/000_config/gitconfig > ~/.gitconfig
  [[ -f "$temp_file" ]] && cat "$temp_file" >> ~/.gitconfig
fi

[[ -f "$temp_file" ]] && rm "$temp_file"

exit 0
