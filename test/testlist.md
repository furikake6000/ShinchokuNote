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
- [ ] delete user: 自分のアカウントが削除できることを確認する
- [ ] delete other user as admin: 他人のアカウントがadmin権限で削除できることを確認する
- [ ] delete other user: 未ログイン状態とnonadminが他人のアカウントを削除できないことを確認する

## NotesControllerTest
- [x] make new note: ログイン状態でノートを作成し成功することを確認する
- [x] make new note of others: 未ログイン状態とログイン状態で他人のノートが作成できないことを確認する
- [x] edit note: ログイン状態でノートを編集し成功することを確認する
- [x] edit note of others: 未ログイン状態とログイン状態で他人のノートが編集できないことを確認する
- [x] delete note: ログイン状態でノートを削除し成功することを確認する
- [x] delete note of others: 未ログイン状態とログイン状態で他人のノートが削除できないことを確認する

## ProjectsControllerTest

## PostsControllerTest
- [ ] make new post: ログイン状態でポストを作成し成功することを確認する
- [ ] make new post of others: 未ログイン状態とログイン状態で他人のポストが作成できないことを確認する
- [ ] edit post: ログイン状態でポストを編集し成功することを確認する
- [ ] edit post of others: 未ログイン状態とログイン状態で他人のポストが編集できないことを確認する
- [ ] delete post: ログイン状態でポストを削除し成功することを確認する
- [ ] delete post of others: 未ログイン状態とログイン状態で他人のポストが削除できないことを確認する

## TweeePostsControllerTest
- [ ] make new tweetpost: 実際のtweetに紐付いたポストを作成しコンテンツの読み取りに成功することを確認する

## CommentsControllerTest
- [x] make new comment(everyone): コメント受け付けスタンス「誰でも」で未ログイン、フォロー外、フォロー内、自分自身でコメントする。すべて正しく動作することを確認する
- [x] make new comment(only_signed): コメント受け付けスタンス「ログインユーザのみ」で未ログイン、フォロー外、フォロー内、自分自身でコメントする。すべて正しく動作することを確認する
- [x] make new comment(only_follower): コメント受け付けスタンス「フォロワーのみ」で未ログイン、フォロー外、フォロー内、自分自身でコメントする。すべて正しく動作することを確認する
- [x] make new comment(only_me): コメント受け付けスタンス「自分のみ」で未ログイン、フォロー外、フォロー内、自分自身でコメントする。すべて正しく動作することを確認する

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

# Fixtures
## Users
### okaka
※Adminとしてのサンプル
twitter_id: 0
name: おかか
screen_name: okakachanbot
url: https://twitter.com/intent/user?user_id=3254249689
thumb_url: https://pbs.twimg.com/profile_images/950164585994108928/ALEUJLCR.jpg
desc: ""
permission: admin
### noritama
※一般ユーザとしてのサンプル
twitter_id: 1
name: のりたま
screen_name: noritama
## Notes
## Posts
