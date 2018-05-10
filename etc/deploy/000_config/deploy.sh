#!/bin/bash
set -eu

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) は ~/.gitconfig を作成するスクリプトである。

Usage:
  $(basename ${0}) [-h]

Options:
  -h print this
EOF
  exit 0
}

while getopts h OPT
do
  case "$OPT" in
    h) usage ;;
    \?) usage ;;
  esac
done

# [user] を設定する
# name, email の値を read コマンドを使って設定する
echo -n "user.name: "; read name
echo -n "user.email: "; read email

# [core] の editor を設定する
# デフォルトは Vi とする
editor=vi
# Vim がインストールされている場合は Vim とする
if [[ $(type vim) ]]; then
  editor=vim
fi

# ~/.gitconfig が存在しており、かつ、"# dotgit" から始まる行があればそこから下の行を一時的に保管しておく
config=~/.gitconfig
temp_file=~/.dotgit.gitconfig
if [[ -f "${config}" ]] && [[ $(grep -q "# dotgit" "${config}"; echo $?) == 0 ]]; then
  end_line=$(awk 'END{print NR}' "${config}")
  start_line=$(grep -n "# dotgit" "${config}" | awk -F: '{print $1}')
  # 開始行と終了行が一致している場合は追加した設定がないので何もしない
  if [[ $start_line != $end_line ]]; then
    start_line=$(expr $start_line + 1)
	sed -n "${start_line},${end_line}p" "${config}" > "${temp_file}"
  fi
fi

# 各種設定を sed で置換して ~/.gitconfig を作成する
sed -e "s/_NAME_/${name}/" -e "s/_EMAIL_/${email}/" -e "s/_EDITOR_/${editor}/" ${DOTGIT}/etc/deploy/000_config/gitconfig > "${config}"
if [[ -f "${temp_file}" ]]; then
  cat "${temp_file}" >> "${config}"
  # 一時ファイルは不要なので削除する
  rm "${temp_file}"
fi

exit 0
