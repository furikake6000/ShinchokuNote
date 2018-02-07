Rails.application.routes.draw do
  # トップページ
  root 'users#home'

  # リソース：ユーザ
  resources :users, only: %i[new index show]
  get '/auth/twitter/callback', to: 'users#login'
  get '/switch', to: 'users#switchuser'
  get '/login', to: 'users#new'
  get '/logout', to: 'users#logout'

  # リソース：ノート
  resources :users, shallow: true do
    # Shallowによりindex, new, createはuserから指定可能
    notetypes = [
      { name: 'Project', sym: :projects },
      { name: 'Idea', sym: :ideas },
      { name: 'FinishedProject', sym: :finishedprojects }
    ]
    notetypes.each do |ntype|
      # 一部イベントのみnotes_controllerで共通処理
      resources ntype[:sym],
                controller: :notes,
                type: ntype[:name],
                only: %i[index destroy]
      # 一部イベント以外は独自コントローラで処理
      resources ntype[:sym]
    end
  end

  # 固定ページ
  get '/about', to: 'static_pages#about'
  get '/manage', to: 'static_pages#manage'

  # ユーザ関連
end
