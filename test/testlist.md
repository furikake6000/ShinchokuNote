# Controller tests
## StaticPagesControllerTest
- [x] access root: ルートページアクセス、レスポンスとテンプレートの確認
- [x] access about: Aboutページアクセス、レスポンスとテンプレートの確認

## UsersControllerTest
- [x] log in: ログイン、ログアウトを1度実行しlogged_in?関数の挙動を確認する
- [x] log in as admin: Admin、非Adminでログインしadmin?関数の挙動を確認する
- [x] log in with two accounts: 複数アカウントでログイン・ログアウトしmaster_userとcurrent_userが合致しているか確認する
- [x] get user index: users/indexページの閲覧（adminしかできない）を非admin/admin双方で行い、アクセス制限ができているか確認する
- [ ] get master_token and secret
- [ ] get current_token and secret

## NotesControllerTest
- [ ] make new note: ログイン状態でノートを作成し成功することを確認する
- [ ] make new note of others: 未ログイン状態とログイン状態で他人のノートが作成できないことを確認する
- [ ] edit note: ログイン状態でノートを編集し成功することを確認する
- [ ] edit note of others: 未ログイン状態とログイン状態で他人のノートが編集できないことを確認する

## ProjectsControllerTest

## PostsControllerTest
- [ ] make new post: ログイン状態でポストを作成し成功することを確認する
- [ ] make new post of others: 未ログイン状態とログイン状態で他人のポストが作成できないことを確認する
- [ ] edit post: ログイン状態でポストを編集し成功することを確認する
- [ ] edit post of others: 未ログイン状態とログイン状態で他人のポストが編集できないことを確認する

## TweeePostsControllerTest
- [ ] make new tweetpost: 実際のtweetに紐付いたポストを作成しコンテンツの読み取りに成功することを確認する

# Model tests

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
