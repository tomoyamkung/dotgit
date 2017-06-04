# dotgit

dotgit とは以下を実行するプロジェクトである。

- ~/.gitconfig の設定
- bash プロンプトへのブランチ表示


# セットアップ手順

セットアップ手順は以下の通り。

```
$ cd ~/
$ git clone https://github.com/tomoyamkung/dotgit.git
$ cd dotgit
$ export DOTGIT=~/dotgit
$ ./etc/deploy.sh  # 本プロジェクトが提供する機能を設定にする
$ . ~/.bashrc  # ~/.bashrc の設定を有効にする
```


# 提供機能

本プロジェクトが提供する機能は非常にシンプルであり、以下だけである。

- ~/.gitconfig の設定
- bash プロンプトへのブランチ表示

セットアップ手順実行後は以下が有効になる。

- ~/.gitconfig が設定されること
- カレントディレクトリが Git プロジェクトの場合にブランチがプロンプトに表示される


## ~/.gitconfig の設定について

~/.gitconfig を生成する機能を提供する。
機能のサマリは以下の通り。

- 以下のスクリプトを実行すると ~/.gitconfig を生成する
    - etc/deploy/000_config/deploy.sh
- 以下の項目を対話的に設定する
    - user.name
    - user.email
- 項目 core.editor については Vim がインストールされていれば Vim を、インストールされていなければ Vi を設定する

alias については以下の通り。

```
[alias]
    br = branch
    ch = checkout
    co = commit
    di = diff
    lo = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
    loa = log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
    st = status -sbu
```

上記スクリプトはデフォルトでは ~/.gitconfig が存在しない場合のみ実行するようになっている。
強制的に上書きしてしまいたい場合は `-f` オプションを指定して実行すること。

その際、~/.gitconfig にある "# dotgit: user specific settings" から下の行は `-f` オプションを付けて実行した場合でも維持されるので消されることはない。
個人・環境ごとに異なる設定を追加したい場合は上記の行より後ろに書いておくこと。


## カレントブランチのプロンプト表示について

bash 限定だが Git で管理されたディレクトリに移動した場合、プロンプトにカレントブランチが表示されるようになる。
プロンプト表示を有効にするには以下のスクリプトを実行すること。

- etc/deploy/000_config/deploy.sh

この機能は Git のソースコードに含まれる git-prompt.sh を利用している。
そのため Git のソースコードを `clone` するようになっているため少々時間がかかってしまう場合がある。

`clone` したソースコードにある git-prompt.sh は以下に `cp` されるようになっている。削除すると正しくプロンプトが表示されなくなるので注意すること。

- ~/.git-prompt.sh


# 仕様・制限事項

本プロジェクトの全体的な仕様、および、制限事項は以下の通り。

- 本プロジェクトは CentOS で開発され CentOS 上での使用を想定しているため、基本的に CentOS 以外での使用は考慮していない
- Git は既に環境にインストールされている状態とする
- シェルは bash を対象とする

