# Controller tests
## StaticPagesControllerTest
- [x] access root: ルートページアクセス、レスポンスとテンプレートの確認
- [x] access about: Aboutページアクセス、レスポンスとテンプレートの確認

## UsersControllerTest
- [x] log in: ログイン、ログアウトを1度実行しlogged_in?関数の挙動を確認する
- [x] log in as admin: Admin、非Adminでログインしadmin?関数の挙動を確認する
- [x] log in with two accounts: 複数アカウントでログイン・ログアウトしmaster_userとcurrent_userが合致しているか確認する
- [x] get user index: users/indexページの閲覧（adminしかできない）を非admin/admin双方で行い、アクセス制限ができているか確認する
- [x] get master_user_token and secret
- [x] get current_user_token and secret
- [x] delete user: 自分のアカウントが削除できることを確認する
- [x] delete other user as admin: 他人のアカウントがadmin権限で削除できることを確認する
- [x] delete other user: 未ログイン状態とnonadminが他人のアカウントを削除できないことを確認する

## NotesControllerTest
- [x] make new note: ログイン状態でノートを作成し成功することを確認する
- [x] make new note of others: 未ログイン状態とログイン状態で他人のノートが作成できないことを確認する
- [x] edit note: ログイン状態でノートを編集し成功することを確認する
- [x] edit note of others: 未ログイン状態とログイン状態で他人のノートが編集できないことを確認する
- [x] delete note: ログイン状態でノートを削除し成功することを確認する
- [x] delete note of others: 未ログイン状態とログイン状態で他人のノートが削除できないことを確認する
- [x] delete note of others as admin: Admin権限で他人のNoteが消せることを確認する

## ProjectsControllerTest

## PostsControllerTest

## TweetPostsControllerTest
- [x] make new tweetpost(link): 実際のtweetに紐付いたポストを作成しコンテンツの読み取りに成功することを確認する
- [x] make new tweetpost(new): 新しくつぶやいてポストを作成しコンテンツの読み取りに成功することを確認する
- [ ] make new tweetpost as others: 未ログイン状態とログイン状態で他人のポストが作成できないことを確認する(new方式で作成する)
- [x] delete post: ログイン状態でポストを削除し成功することを確認する
- [x] delete post(with tweet): ログイン状態でポストを削除し(Tweetごと)成功することを確認する
- [x] delete post of others: 未ログイン状態とログイン状態で他人のポストが削除できないことを確認する


## CommentsControllerTest
- [x] make new comment(everyone): コメント受付スタンス「誰でも」で未ログイン、フォロー外、フォロー内、自分自身でコメントする。すべて正しく動作することを確認する
- [x] make new comment(only_signed): コメント受付スタンス「ログインユーザのみ」で(ry
- [x] make new comment(only_follower): コメント受付スタンス「フォロワーのみ」で(ry
- [x] make new comment(only_me): コメント受付スタンス「自分のみ」で(ry

- [ ] show comment(everyone): コメント表示スタンス「誰でも」で未ログイン、フォロー外、フォロー内、自分自身でnote#showの表示とcomment#showの表示を確認する。すべて正しく動作することを確認する
- [ ] show comment(only_signed): コメント表示スタンス「誰でも」で(ry
- [ ] show comment(only_follower): コメント表示スタンス「誰でも」で(ry
- [ ] show comment(only_me): コメント表示スタンス「誰でも」で(ry

# Model tests
## UserTest
- [x] valid user: okakaを召喚してvalidを確認
- [x] invalid user uniqueness: okakaを保存した後にokakaのvalidationを確認して一意性の確認
- [x] invalid user no_twitter_id: twitter_idのないUserがinvalidであることを確認
- [x] admin and nonadmin: okakaとnoritamaのadmin?を確認

## NoteTest
- [x] valid note: okaka_project_1を召喚してvalidを確認
- [x] invalid note uniqueness: 同ユーザが同じ名前のNoteを保存しようとして一意性の確認
- [x] invalid note no_type: typeのないNoteがinvalidであることを確認
- [x] invalid note wrong_type: 存在しないtype「'Undefined'」のNoteがinvalidであることを確認

## ProjectTest
- [ ] valid project: okaka_project_1を召喚してvalidを確認
- [ ] invalid project no_name: nameのないProjectがinvalidであることを確認

## PostTest
- [x] valid post: okaka_project_tweetpost_1を召喚してvalidを確認
- [x] invalid post no_type: typeのないPostがinvalidであることを確認
- [x] invalid post wrong_type: 存在しないtype「'Undefined'」のPostがinvalidであることを確認

# Helper tests
## ApplicationHelperTest
- [x] Encryption and decryption: encrypt_dataしたものをdecrypt_dataし整合性を確認
- [x] Encryption and decryption for Json: Jsonデータをencrypt, decryptし整合性を確認
- [x] get_fullsize_thumb_uri: 'get_fullsize_thumb_uri'メソッドの動作を確認

## TwitterHelperTest
- [x] client_new success: 実在するtokenとsecretを使ってclient_newを行い取得できるか（nilでないか）を確認
- [x] client_new failure: ダミーのtokenとsecretを使ってclient_newを行い取得できないことを確認

# Integration tests
