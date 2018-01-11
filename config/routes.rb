Rails.application.routes.draw do
  #トップページ
  root 'users#home'

  #リソース：ユーザ
  resources :users, :path => 'u', :only => [:index, :new, :show]

  #固定ページ
  get '/about', to: 'static_pages#about'

  #ユーザ関連
  get '/auth/twitter/callback', to: 'users#login'
  get '/switch', to: 'users#switchuser'

end
