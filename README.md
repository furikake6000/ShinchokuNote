# 進捗ノート(Shinchoku Note/ Progress notebooks)

進捗ノートは、同人製作者のためのツールです。

* 環境(Environments)

** Ruby 2.3.1
** Rails 5.1.4
** puma 3.7
** nginx

* クラス構成(Classes)

詳細な構成はdocs/shinchokunote.astaをご覧ください。
** Userクラス
ユーザ情報を格納するクラスです。Userは複数のNoteを持ちます。

** Noteクラス
情報をまとめるノートクラスです。基本的に抽象クラス扱いであり、ここから様々な種類のNoteが派生します。Postの投稿、Commentの受付、ShinchokuDodeskaの受付、ウォッチリストへの登録が可能です。
*** Projectクラス < Note
自分の進めているプロジェクトを表すクラスです。
*** RequestBoxクラス < Note
コメントを受け付けるためのノートを表すクラスです。

** Postクラス
進捗報告などの投稿一つ一つを表すクラスです。
*** TweetPostクラス < Post
Twitterに投稿されたツイートをそのままPostとして扱うことができます。
基本的に当サービスのPostはTweetPostです。

** Commentクラス
Noteに対しコメントすることができます。

** Shinchokudodeskaクラス
Noteに対し「進捗どうですか」のアクションを行うことができます。

** UserWatchesNoteクラス
ウォッチリスト用の多対多構造作成用のクラスです。
