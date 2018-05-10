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

prompt_script_path=~/.git-prompt.sh
# ~/.bashrc に設定が存在する場合は処理を終了する
grep -q "${prompt_script_path}" ~/.bashrc && exit 0

if [[ ! -f "${prompt_script_path}" ]]; then
  # git-prompt.sh を取得するため /tmp に git を clone する
  # clone したプロジェクトから git-prompt.sh を検索してホームディレクトリにコピーする
  git clone https://github.com/git/git.git /tmp/git
  find /tmp/git/ -type f -name "git-prompt.sh" | xargs -i cp {} "${prompt_script_path}"
  rm -fr /tmp/git/
fi

# ~/.bashrc にプロンプトの設定を追加する
cat ${DOTGIT}/etc/deploy/010_prompt/bash/prompt >> ~/.bashrc

exit 0
