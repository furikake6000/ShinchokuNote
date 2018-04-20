Rails.application.routes.draw do
  # トップページ
  root 'users#home'

  # リソース：ユーザ
  # Shallowによりindex, new, createはuserから指定可能
  resources :users, except: %i[create destroy], shallow: true do
    # リソース：ノート
    resources :notes, shallow: true do
      # リソース:投稿
      resources :posts, only: %i[index destroy]

      # リソース:コメント
      resources :comments, only: %i[index create show update destroy]

      # Post派生クラスTwitterPostはcreateのみ許可
      resources :tweet_posts, only: :create

      # ノートに対しWatchlist#Createができる
      resources :watchlists, only: %i[create destroy]
      post '/watchlists/toggle', to: 'watchlists#toggle'

      # 進捗どうですか
      resources :shinchoku_dodeskas, only: :create
    end

    # 削除メニュー
    # get '/leave', to: 'users#leave'
  end

  get '/auth/twitter/callback', to: 'users#login'
  get '/switch', to: 'users#switchuser'
  get '/login', to: 'users#new'
  get '/logout', to: 'users#logout'
  get '/notifications', to: 'users#notifications'
  get '/omakase', to: 'notes#omakase'

  # 固定ページ
  get '/about', to: 'static_pages#about'
  get '/manage', to: 'static_pages#manage'

  # ユーザ関連
end
