#!/bin/bash
set -eu

# ライブラリスクリプトを読み込む
. ${DOTGIT?"export DOTGIT=~/dotgit"}/bin/lib/dry_run.sh

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) は etc/deploy/**/deploy.sh を一括して実行するスクリプトである。

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

${dryrun} ${DOTGIT}/etc/deploy/000_config/deploy.sh
if [[ $? == 0 ]]; then
  find ${DOTGIT}/etc/deploy -type f -name "deploy.sh" | sort | grep -v "000_config" | xargs -i ${dryrun} sh {}
fi

exit 0
