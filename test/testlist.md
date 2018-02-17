# Controller tests
## StaticPagesControllerTest
- [x] access root: ルートページアクセス、レスポンスとテンプレートの確認
- [x] access about: Aboutページアクセス、レスポンスとテンプレートの確認
## UsersControllerTest
- [x] log in: ログイン、ログアウトを1度実行しlogged_in?関数の挙動を確認する
- [x] log in as admin: Admin、非Adminでログインしadmin?関数の挙動を確認する
- [x] log in with two accounts: 複数アカウントでログイン・ログアウトしmaster_userとcurrent_userが合致しているか確認する
- [x] get user index: users/indexページの閲覧（adminしかできない）を非admin/admin双方で行い、アクセス制限ができているか確認する

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
