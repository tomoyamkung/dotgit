#!/bin/bash
set -eu

# ライブラリスクリプトを読み込む
. ${DOTGIT?"export DOTGIT=~/dotgit"}/bin/lib/dry_run.sh

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) はプロンプトにブランチを表示する設定を行うスクリプトである。
  bash を対象とする。

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

# ~/.bashrc に設定が存在する場合は処理を終了する
grep -q "~/.git-prompt.sh" ~/.bashrc && exit 0

# git-prompt.sh を取得するため /tmp に git を clone する
if [[ ! -d /tmp/git ]]; then
  ${dryrun} git clone https://github.com/git/git.git /tmp/git
fi
# clone したプロジェクトから git-prompt.sh を検索してホームディレクトリにコピーする
if [[ ! -z ${dryrun} ]]; then
  ${dryrun} 'find /tmp/git/ -type f -name "git-prompt.sh" | xargs -i echo cp ~/.git-prompt.sh'
else
  find /tmp/git -type f -name "git-prompt.sh" | xargs -i cp {} ~/.git-prompt.sh
fi

# ~/.bashrc にプロンプトの設定を追加する
if [[ ! -z ${dryrun} ]]; then
  cat ${DOTGIT}/etc/deploy/010_prompt/bash/prompt
else
  cat ${DOTGIT}/etc/deploy/010_prompt/bash/prompt >> ~/.bashrc
fi

exit 0
