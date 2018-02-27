Rails.application.routes.draw do
  # トップページ
  root 'users#home'

  # リソース：ユーザ
  # Shallowによりindex, new, createはuserから指定可能
  resources :users, except: %i[create destroy], shallow: true do
    # リソース：ノート
    resources :notes, shallow: true do
      # リソース:投稿
      resources :posts

      # Post派生クラスTwitterPostはcreateのみ許可
      resources :tweet_posts, only: %i[create]
    end
  end

  get '/auth/twitter/callback', to: 'users#login'
  get '/switch', to: 'users#switchuser'
  get '/login', to: 'users#new'
  get '/logout', to: 'users#logout'

  # 固定ページ
  get '/about', to: 'static_pages#about'
  get '/manage', to: 'static_pages#manage'

  # ユーザ関連
end
