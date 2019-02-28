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