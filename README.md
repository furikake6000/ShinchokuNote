# 進捗ノート(Shinchoku Note/ Progress notebooks)

進捗ノートは、同人製作者のためのツールです。

## 環境(Environments)

+ Ruby 2.3.1
+ Rails 5.1.4
+ puma 3.7
+ nginx

## リリースノート(Release Notes)

### ver 1.0.0

2018/08/19

+ **Twitterへ共有しない画像の投稿が可能になりました。**ただし、現在試作中の機能のため、予告せず停止・改変する可能性があります。ご注意ください。
+ 複数枚の画像投稿時に表示される<>ボタンをより見えやすくしました。
+ ユーザーの退会機能を付けました。ユーザー編集ページの最下部から退会することができます。退会後、再登録すると過去のデータが復元できます。
+ レーティング設定が可能になりました。18歳未満にセンシティブなノートはノート編集ページより再設定をお願いいたします。
+ 「ウォッチリスト」や「みんなの進捗」メニューに**「続きを見る」ボタンを作成**しました。今までは最初に表示されている範囲しか見られませんでしたが、より古い投稿を見ることができます。

### ver 0.6.3

2018/7/25

+ ヘルプページと「よくある質問」ページを整備いたしました。上部にいる進捗ちゃんをクリックするとヘルプページが見られます（今まではベータ版のページが表示されていた）。
+ スケジュールを完了した時に、予定順でなく完了した順に並ぶようになりました。
+ ノートの新規作成ページから公開範囲などの設定ができるようになりました。

### ver 0.6.2

2018/7/14

+ 新しい画像投稿フォームがInternet Explorerに対応しました。(IE11にて動作確認)
+ 画像を複数枚投稿する際にエラーが発生しやすかった問題を修正しました。

### ver 0.6.1

2018/7/10

+ 新しい画像フォームで自動縮小されるファイルサイズ上限を緩くしました。(1MB→5MB)
+ ノートがいつ作成されたか、説明文の下に書かれるようになりました。
+ 雑多なバグ修正。

### ver 0.6

2018/7/7

+ Webpush通知に対応しました。ダイアログから「通知を許可する」をクリックすることで通知が可能になります。
  + 現状「コメントが届いた」「『進捗どうですか』が届いた」で通知します（設定変更可能）。
  + 今後「スケジュールが近づいた」「特定のノートに投稿があった」などの通知も設定できるようにする予定です。
+ 画像投稿フォームを改修しました。
  + (PC版)ドラッグドロップで添付が可能になりました。
  + 投稿された画像プレビューをクリックで「編集ダイアログ」が開きます。編集ダイアログでは現在画像トリミングのみが可能です。

### ver 0.5.1

2018/6/25

+ 「ユーザーのノート一覧を共有」のツイート時のリンクが誤っていたため修正しました。
+ 依存パッケージのアップデートを行いました。

### ver 0.5

2018/6/24

+ **ツイートしない投稿が可能になりました(テキストのみ)。**画像投稿への対応は可能な限り早く行いますが、もう少しお待ちください...
+ **検索機能を実装しました。**上部バーに「検索」ボタンを配置しました。ノートのタイトルで検索が可能です。
+ バグ修正を行いました。
  + 「ユーザーのノート一覧を共有」のリンクが誤っていたため修正しました。
  + 「ユーザーの最近のノート」に最近投稿のあったノートを正しく表示するように修正しました。

### ver 0.4.8

2018/6/21

緊急性のあるバグ修正を行いました。

+ 一部投稿が正常に表示できないバグを修正しました。
+ ついでに、ノート説明テキストやユーザープロフィールにおいて改行が正しく表示されるようにしました。
+ ついでに、ノート説明テキストやユーザープロフィールにおいてURLが含まれている場合自動的にリンクを貼るようにしました。

### ver 0.4.7

2018/6/20

+ スケジュールを編集可能にしました。各スケジュールの鉛筆ボタンを押すと編集画面に飛びます。
+ 通知件数に関する仕様を変更しました。「通知を確認済みにする」を押さなくとも、既に見た通知はトップページの件数には追記されません。
+ ノートページの「ウォッチリスト」「コメント」「進捗どうですか」ボタンを少し大きくしました。PC版では、カーソルを合わせると説明が出るようにしました。
+ 公式からのお知らせを表示できるようにしました。今後、メンテナンス情報、アップデート情報などはこちらのページからお伝えいたします！

### ver 0.4.6

2018/6/16

(※ver 0.4.1 〜 0.4.5は内部的なアップデートのため省略しています。)

+ 「ユーザーを追加する」が機能していない問題を修正しました。
+ 複数枚の画像投稿を表示するとき、勝手に切り替わらないようにしました。
+ **ノートごとに公開制限ができるようになりました**。「だれでも」「匿名ユーザー以外」「フォロワーさんのみ」「自分のみ」から選択できるほか、「みんなの進捗」「おまかせ表示」に出すかどうかも選択できます。

### ver 0.4.0

2018/6/4

+ **スケジュール機能の追加**。進捗報告と同じフォームから、「○月○日の○時までにこれを完成させたい！」というスケジュールを追加できるようになりました。現状特に機能はありませんが、締め切りの近いスケジュールのアラーム機能など、今後充実させていく予定です。

### ver 0.3.1

2018/6/1

+ iOSにおいてユーザーメニューが表示されなかった問題の修正

### ver 0.3.0

2018/5/31

+ **デザインの大幅な変更。**
+ 「進捗を記すノート」というコンセプトを省みて、全体的に明るいテーマにしました。それぞれのノートの色付けも、オレンジや水色のパステルカラーを使用。よりシンプルになりました。
+ 各ノートのページは、**「月」を重視したデザイン** にしました。1ヶ月でどれくらいのことをしたのか分かりやすくなり、月別リンクもご用意したために過去の進捗へアクセスしやすくなりました。
+ 雑多なバグの修正。

### ver 0.2.0

2018/5/23

+ **アイコンやアカウントネームを更新するボタン** を設置しました。マイページ右上の「ユーザー情報反映」をクリックで最新の状態に更新します。
+ **長文ツイートに画像を添付したときに表示されない問題を修正** しました。
+ トップページに **「ユーザーを見つける」** を設置し、Twitter上でフォローしているユーザーを進捗ノート上で見つけやすくなりました。
+ **デザインを一部変更** し、色分けにより **プロジェクト** と **リクエストボックス** がわかりやすくなるようにしました。
+ 雑多な **バグの修正** を行いました。

### ver 0.1.3

2018/5/13

+ ノートをウォッチリストに登録しているユーザー(ウォッチャー)の一覧を表示するように
+ ノートのシェアをするときに開くツイートウィンドウが新規タブで開くように
+ 空白のままコメントや投稿ができてしまう問題の修正
+ 通知の確認済み処理を変更(自分でボタンを押すまでは消えない)
+ 細かいバグの修正

### ver 0.1.2

2018/5/8

+ 新規進捗投稿時の「URLから紐付け」が正常にできない問題の修正
+ 文字数の多い新規投稿を行おうとするとエラーになる問題の修正(文字数の制限)
+ 新規投稿やコメントへの返信時に文字数を表示
+ 細かいバグの修正

### ver 0.1.1

2018/5/5

+ 画像投稿フォームにマウスを載せる際にカーソルが変わるように
+ 「おまかせ表示」をした際に一瞬他のページが見える現象の修正(キャッシュの無効化)
+ コメントや投稿の改行を正しく表示するように
+ コメントや投稿で長い英単語を打った場合にはみ出ない(改行される)ように
+ 通知ページの表示からその通知元のノートに飛べるようにリンクを設置
+ リリースノートを追加

### ver 0.1.0

2018/5/4
(正式には4/29(進捗の日))
ベータ版最初のリリース

## クラス構成(Classes)

詳細な構成はdocs/shinchokunote.astaをご覧ください。

### Userクラス

ユーザー情報を格納するクラスです。Userは複数のNoteを持ちます。

### Noteクラス

情報をまとめるノートクラスです。基本的に抽象クラス扱いであり、ここから様々な種類のNoteが派生します。Postの投稿、Commentの受付、ShinchokuDodeskaの受付、ウォッチリストへの登録が可能です。

### Projectクラス < Note

自分の進めているプロジェクトを表すクラスです。

### RequestBoxクラス < Note

コメントを受け付けるためのノートを表すクラスです。

### Postクラス

進捗報告などの投稿一つ一つを表すクラスです。

### TweetPostクラス < Post

Twitterに投稿されたツイートをそのままPostとして扱うことができます。
基本的に当サービスのPostはTweetPostです。

+ Commentクラス

Noteに対しコメントすることができます。

+ Shinchokudodeskaクラス

Noteに対し「進捗どうですか」のアクションを行うことができます。

+ UserWatchesNoteクラス

ウォッチリスト用の多対多構造作成用のクラスです。
