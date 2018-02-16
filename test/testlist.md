# Controller tests
## StaticPagesControllerTest
- Home test: 未ログイン時のルートページ表示の確認
- About page test: aboutページの表示の確認
## UsersControllerTest
- logging in: ログイン、ログアウトを1度実行しlogged_in?関数の挙動を確認する
- logging in as admin: Admin、非Adminでログインしadmin?関数の挙動を確認する
- logging in with two accounts: 複数アカウントでログイン・ログアウトしmaster_userとcurrent_userが合致しているか確認する
- getting user index: users/indexページの閲覧（adminしかできない）を非admin/admin双方で行い、アクセス制限ができているか確認する

# Model tests

# Integration tests
