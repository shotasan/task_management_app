### Herokuにデプロイする方法
- アセットプリコンパイルする `rails assets:precompile RAILS_ENV=production`
- コミットする `git add -A` `git commit -m "message"`
- デプロイする `git push heroku master`
***

### バージョン情報
Ruby 2.6.1
Rails 5.2.2
DB psql (PostgreSQL) 11.2
bootstrap3
***

モデル名
テーブル名
カラム: データ型

***
<h4>userモデル</h4>
usersテーブル
name: string
email: string
password_digest: string
***
<h4>taskモデル</h4>
tasksテーブル
title: string
content: text_area
***
<h4>labelモデル</h4>
labelsテーブル
title: string
***
<h4>related of task and labelモデル</h4>
related_of_tasks_and_labels
task_id: integer
label_id: integer