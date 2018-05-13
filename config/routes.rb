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
      resources :comments, only: %i[create show update destroy]
      constraints lambda { |req| req.format == :js } do
        resources :comments, only: :index
      end

      # Post派生クラスTwitterPostはcreateのみ許可
      resources :tweet_posts, only: :create

      # ノートに対しWatchlist#Createができる
      resources :watchlists, only: %i[create destroy]
      post '/watchlists/toggle', to: 'watchlists#toggle'

      # ウォッチャー一覧ページ
      get '/watchers', to: 'notes#watchers'

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
  post '/notifications', to: 'users#notifications_checked'
  get '/omakase', to: 'notes#omakase'

  # 固定ページ
  get '/about', to: 'static_pages#about'
  get '/faq', to: 'static_pages#faq'
  get '/manage', to: 'static_pages#manage'
  get '/beta', to: 'static_pages#beta'

  # ユーザ関連
end
