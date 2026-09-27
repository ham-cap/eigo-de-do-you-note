# サービス終了手順（Runbook）

このドキュメントは、2026年10月31日のサービス終了に合わせて本番環境を停止・破棄し、
リポジトリの保守を終了するための手順書です。実行はすべて手動で行い、自動化はしていません。

前提: `flyctl` がインストール済みで、Fly.io アカウントへのアクセス権があること。
GitHub リポジトリの admin 権限があること（`gh` CLI 使用時）。

## 0. 事前準備（終了日の1〜2週間前を目安に）

- [ ] README・アプリ内バナーで告知済みであることを確認する
- [ ] `flyctl auth login` でログインする
- [ ] Google Cloud Console / DeepL のダッシュボードへのアクセスを確認しておく

## 1. データのバックアップ（終了日当日、停止直前）

Postgres の内容を万一の問い合わせ対応用に退避する。

```sh
flyctl status -a eigo-de-do-you-note
flyctl postgres list
# アプリが利用しているPostgresアプリ名を確認のうえ
flyctl postgres connect -a <postgres-app-name>
# 接続後、pg_dump 相当が必要な場合は以下のように取得する
flyctl ssh console -a <postgres-app-name> -C "pg_dump -Fc -d <dbname> -f /tmp/backup.dump"
flyctl sftp get /tmp/backup.dump ./backup-$(date +%Y%m%d).dump -a <postgres-app-name>
```

バックアップは社内の安全なストレージに保管し、一定期間（例: 90日）経過後に削除する。

## 2. アプリケーションの停止

いきなり破棄せず、まずマシンを止めて動作確認する。

```sh
flyctl apps list
flyctl scale count 0 -a eigo-de-do-you-note
flyctl status -a eigo-de-do-you-note
```

`https://eigo-de-do-you-note.fly.dev` にアクセスし、応答しなくなっていることを確認する。

## 3. GitHub Actions の自動デプロイを止める

停止後に誤って再デプロイされないよう、デプロイワークフローを無効化する
（このタイミングでリポジトリはまだ Archive しない）。

```sh
gh workflow disable "Fly Deploy" -R ham-cap/eigo-de-do-you-note
```

## 4. Fly.io リソースの削除

問題がないことを確認できたら、アプリと Postgres・ボリュームを削除する。
**この操作は不可逆です。** 手順1のバックアップが完了していることを再確認してから実行する。

```sh
flyctl volumes list -a eigo-de-do-you-note
flyctl volumes destroy <volume-id> -a eigo-de-do-you-note

flyctl apps destroy eigo-de-do-you-note

# DB を専用アプリとして運用している場合
flyctl apps destroy <postgres-app-name>
```

カスタムドメインや証明書を設定している場合は、DNS レコードの削除も行う。

## 5. 外部サービスの認証情報を無効化する

- [ ] Google Cloud Console で OAuth クライアント（`GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET`）を削除する
- [ ] DeepL API キー（`DEEPL_API_KEY`）を無効化する
- [ ] GitHub リポジトリの Secrets（`FLY_API_TOKEN`, `DEEPL_API_KEY` など）を削除する
  ```sh
  gh secret list -R ham-cap/eigo-de-do-you-note
  gh secret delete FLY_API_TOKEN -R ham-cap/eigo-de-do-you-note
  gh secret delete DEEPL_API_KEY -R ham-cap/eigo-de-do-you-note
  ```

## 6. リポジトリのアーカイブ

すべての停止作業が完了したら、最後にリポジトリを Archive する。
Archive すると push・Issue作成・Actions の実行ができなくなる（読み取り専用になる）。

```sh
gh repo archive ham-cap/eigo-de-do-you-note
```

## 7. 完了確認チェックリスト

- [ ] `https://eigo-de-do-you-note.fly.dev` にアクセスできない
- [ ] Fly.io の Apps 一覧に本アプリが存在しない
- [ ] Google / DeepL の認証情報が無効化されている
- [ ] GitHub リポジトリが Archived 表示になっている
- [ ] バックアップデータの保管場所と削除予定日を記録した
