# == Route Map
#
#                         Prefix Verb   URI Pattern                                                                              Controller#Action
#                     okcomputer        /health                                                                                  OkComputer::Engine
#                           root GET    /                                                                                        users#home
#                     note_posts GET    /notes/:note_id/posts(.:format)                                                          posts#index
#                                POST   /notes/:note_id/posts(.:format)                                                          posts#create
#                           post DELETE /posts/:id(.:format)                                                                     posts#destroy
#                  note_comments GET    /notes/:note_id/comments(.:format)                                                       comments#index
#                                POST   /notes/:note_id/comments(.:format)                                                       comments#create
#                        comment GET    /comments/:id(.:format)                                                                  comments#show
#                                PATCH  /comments/:id(.:format)                                                                  comments#update
#                                PUT    /comments/:id(.:format)                                                                  comments#update
#                                DELETE /comments/:id(.:format)                                                                  comments#destroy
#                                GET    /notes/:note_id/comments(.:format)                                                       comments#index
#               note_tweet_posts POST   /notes/:note_id/tweet_posts(.:format)                                                    tweet_posts#create
#                 note_schedules POST   /notes/:note_id/schedules(.:format)                                                      schedules#create
#                  edit_schedule GET    /schedules/:id/edit(.:format)                                                            schedules#edit
#                       schedule PATCH  /schedules/:id(.:format)                                                                 schedules#update
#                                PUT    /schedules/:id(.:format)                                                                 schedules#update
#                note_watchlists POST   /notes/:note_id/watchlists(.:format)                                                     watchlists#create
#                      watchlist DELETE /watchlists/:id(.:format)                                                                watchlists#destroy
#         note_watchlists_toggle POST   /notes/:note_id/watchlists/toggle(.:format)                                              watchlists#toggle
#                  note_watchers GET    /notes/:note_id/watchers(.:format)                                                       notes#watchers
#        note_shinchoku_dodeskas POST   /notes/:note_id/shinchoku_dodeskas(.:format)                                             shinchoku_dodeskas#create
# note_shinchoku_dodeskas_toggle POST   /notes/:note_id/shinchoku_dodeskas/toggle(.:format)                                      shinchoku_dodeskas#toggle
#                note_new_viewer GET    /notes/:note_id/new_viewer(.:format)                                                     notes#new_viewer
#                     user_notes GET    /users/:user_id/notes(.:format)                                                          notes#index
#                                POST   /users/:user_id/notes(.:format)                                                          notes#create
#                  new_user_note GET    /users/:user_id/notes/new(.:format)                                                      notes#new
#                      edit_note GET    /notes/:id/edit(.:format)                                                                notes#edit
#                           note GET    /notes/:id(.:format)                                                                     notes#show
#                                PATCH  /notes/:id(.:format)                                                                     notes#update
#                                PUT    /notes/:id(.:format)                                                                     notes#update
#                                DELETE /notes/:id(.:format)                                                                     notes#destroy
#                          users GET    /users(.:format)                                                                         users#index
#                       new_user GET    /users/new(.:format)                                                                     users#new
#                      edit_user GET    /users/:id/edit(.:format)                                                                users#edit
#                           user GET    /users/:id(.:format)                                                                     users#show
#                                PATCH  /users/:id(.:format)                                                                     users#update
#                                PUT    /users/:id(.:format)                                                                     users#update
#                                DELETE /users/:id(.:format)                                                                     users#destroy
#                                POST   /notes/:id(.:format)                                                                     notes#update
#                      announces GET    /announces(.:format)                                                                     announces#index
#                                POST   /announces(.:format)                                                                     announces#create
#                       announce GET    /announces/:id(.:format)                                                                 announces#show
#                                PATCH  /announces/:id(.:format)                                                                 announces#update
#                                PUT    /announces/:id(.:format)                                                                 announces#update
#                                DELETE /announces/:id(.:format)                                                                 announces#destroy
#                        devices POST   /devices(.:format)                                                                       devices#create
#                    user_blocks GET    /user_blocks(.:format)                                                                   user_blocks#index
#                                POST   /user_blocks(.:format)                                                                   user_blocks#create
#                     user_block DELETE /user_blocks/:id(.:format)                                                               user_blocks#destroy
#                         search GET    /search(.:format)                                                                        search#search
#          auth_twitter_callback GET    /auth/twitter/callback(.:format)                                                         users#login
#                         switch GET    /switch(.:format)                                                                        users#switchuser
#                     updateuser GET    /updateuser(.:format)                                                                    users#updateuser
#              recommended_users GET    /recommended_users(.:format)                                                             users#recommended_users
#                          login GET    /login(.:format)                                                                         users#new
#                         logout POST   /logout(.:format)                                                                        users#logout
#                  notifications GET    /notifications(.:format)                                                                 users#notifications
#                                POST   /notifications(.:format)                                                                 users#notifications_checked
#                        omakase GET    /omakase(.:format)                                                                       notes#omakase
#                   newest_posts GET    /newest_posts(.:format)                                                                  posts#newest_posts
#                 watching_posts GET    /watching_posts(.:format)                                                                posts#watching_posts
#                          about GET    /about(.:format)                                                                         static_pages#about
#                            faq GET    /faq(.:format)                                                                           static_pages#faq
#                           help GET    /help(.:format)                                                                          static_pages#help
#                         manage GET    /manage(.:format)                                                                        static_pages#manage
#                          terms GET    /terms(.:format)                                                                         static_pages#terms
#                    api_v1_note GET    /api/v1/notes/:id(.:format)                                                              api/v1/notes#show
#             rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#      rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#             rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#      update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#           rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
# 
# Routes for OkComputer::Engine:
#              root GET|OPTIONS /                 ok_computer/ok_computer#show {:check=>"default"}
# okcomputer_checks GET|OPTIONS /all(.:format)    ok_computer/ok_computer#index
#  okcomputer_check GET|OPTIONS /:check(.:format) ok_computer/ok_computer#show

Rails.application.routes.draw do
  # トップページ
  root 'users#home'

  # リソース：ユーザー
  # Shallowによりindex, new, createはuserから指定可能
  resources :users, except: :create, shallow: true do
    # リソース：ノート
    resources :notes, shallow: true do
      # リソース:投稿
      resources :posts, only: %i[index create destroy]

      # リソース:コメント
      resources :comments, only: %i[index create show update destroy]
      constraints lambda { |req| req.format == :js } do
        resources :comments, only: :index
      end

      # Post派生クラスTwitterPost
      resources :tweet_posts, only: :create
      # Post派生クラスSchedule
      resources :schedules, only: %i[create edit update]

      # ノートに対しWatchlist#Createができる
      resources :watchlists, only: %i[create destroy]
      post '/watchlists/toggle', to: 'watchlists#toggle'

      # ウォッチャー一覧ページ
      get '/watchers', to: 'notes#watchers'

      # 進捗どうですか
      resources :shinchoku_dodeskas, only: :create
      post '/shinchoku_dodeskas/toggle', to: 'shinchoku_dodeskas#toggle'

      # 新ノートページ(仮置き、最終的にNote#showに)
      get '/new_viewer', to: 'notes#new_viewer'
    end

    # 削除メニュー
    # get '/leave', to: 'users#leave'
  end

  # Firefox等一部ブラウザにおいて、PATCHメソッドのフォームがPOSTになってしまう問題の解消用
  post '/notes/:id', to: 'notes#update'

  # リソース:アナウンス
  resources :announces, only: %i[index create update show destroy]

  # リソース:デバイス(Webpushに使用)
  resources :devices, only: [:create]

  # リソース:ユーザーブロック
  resources :user_blocks, only: %i[index create destroy]

  get '/search', to: 'search#search'
  get '/auth/twitter/callback', to: 'users#login'
  get '/switch', to: 'users#switchuser'
  get '/updateuser', to: 'users#updateuser'
  get '/recommended_users', to: 'users#recommended_users'
  get '/login', to: 'users#new'
  post '/logout', to: 'users#logout'
  get '/notifications', to: 'users#notifications'
  post '/notifications', to: 'users#notifications_checked'
  get '/omakase', to: 'notes#omakase'

  # Ajaxでの取得
  get '/newest_posts', to: 'posts#newest_posts'
  get '/watching_posts', to: 'posts#watching_posts'

  # 固定ページ
  get '/about', to: 'static_pages#about'
  get '/faq', to: 'static_pages#faq'
  get '/help', to: 'static_pages#help'
  get '/manage', to: 'static_pages#manage'
  get '/terms', to: 'static_pages#terms'

  # ユーザー関連

  # Vue向けAPI
  namespace 'api', format: 'json' do
    namespace 'v1' do
      resources :notes, only: %i[show]
    end
  end
end
