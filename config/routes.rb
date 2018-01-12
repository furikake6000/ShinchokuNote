Rails.application.routes.draw do
  #トップページ
  root 'users#home'

  #リソース：ユーザ
  resources :users, :only => [:index, :new]
  get '/u/:id', to: 'users#show'

  #固定ページ
  get '/about', to: 'static_pages#about'
  get '/manage', to: 'static_pages#manage'

  #ユーザ関連
  get '/auth/twitter/callback', to: 'users#login'
  get '/switch', to: 'users#switchuser'
  get '/logout', to: 'users#logout'

end
