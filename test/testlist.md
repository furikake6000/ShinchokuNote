# Controller tests
## StaticPagesControllerTest
- [x] access root: ルートページアクセス、レスポンスとテンプレートの確認
- [x] access about: Aboutページアクセス、レスポンスとテンプレートの確認
## UsersControllerTest
- [x] logging in: ログイン、ログアウトを1度実行しlogged_in?関数の挙動を確認する
- [x] logging in as admin: Admin、非Adminでログインしadmin?関数の挙動を確認する
- [x] logging in with two accounts: 複数アカウントでログイン・ログアウトしmaster_userとcurrent_userが合致しているか確認する
- [x] getting user index: users/indexページの閲覧（adminしかできない）を非admin/admin双方で行い、アクセス制限ができているか確認する

# Model tests

# Integration tests
