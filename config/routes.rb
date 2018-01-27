Rails.application.routes.draw do
  #トップページ
  root 'users#home'

  #リソース：ユーザ
  resources :users, :only => [:new, :index, :show, :new]
  get '/login', to: 'users#new'
  get '/u/:id', to: 'users#show'  #リンク用短縮エイリアス
  get '/auth/twitter/callback', to: 'users#login'
  get '/switch', to: 'users#switchuser'
  get '/logout', to: 'users#logout'

  #リソース：ノート
  resources :users, shallow:true do
    #Shallowによりindex, new, createはuserから指定可能
    resources :notes
  end
  get '/n/:id', to: 'notes#show'  #リンク用短縮エイリアス

  #固定ページ
  get '/about', to: 'static_pages#about'
  get '/manage', to: 'static_pages#manage'

  #ユーザ関連

end
