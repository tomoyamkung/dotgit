#!/bin/bash
set -eu

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) はプロンプトにブランチを表示する設定を行うスクリプトである。
  bash を対象とする。

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


# ~/.bashrc にプロンプトの設定を追加する
prompt_script_path=~/.git-prompt.sh
if [[ ! -f "${prompt_script_path}" ]]; then
  curl -o "${prompt_script_path}" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
  chmod 755 "${prompt_script_path}"
fi
if [[ ! `grep -q "${prompt_script_path}" ~/.bashrc` ]]; then
  cat <<'EOF' >> ~/.bashrc
[ -f ~/.git-prompt.sh ] && source ~/.git-prompt.sh
PS1='[\u@\h \W`__git_ps1`]\$ '
export PS1=${PS1}
EOF
fi

# `git` コマンドの補完スクリプト設定を追加する
completion_script_path=~/.git-completion.bash
if [[ ! -f "${completion_script_path}" ]]; then
  curl -o "${completion_script_path}" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
  chmod 755 "${ompletion_script_path}"
fi
if [[ ! `grep -q "${completion_script_path}" ~/.bashrc` ]]; then
  echo "source ${completion_script_path}" >> ~/.bashrc
fi
exit 0
