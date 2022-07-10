# Runbook

## How to start

- 指定されているユーザに`sudo -i -u`をつかって切り替え、このリポジトリをクローンする。

```
sudo -i -u isucon
git clone https://github.com/VTRyo/vtryo-isucon-setup
```

- tools/setup.shに情報を追加する

DB情報やサービス情報を読み取り、setup.shに入力する。

```
DB_USER:=
DB_PASS:=
DB_NAME:=
RUBY_SERV:=
BENCH_CMD:=
```

## ログの場所

原則ミドルウェアのログは`/var/log/isucon/`配下に出力するように設定しています。
