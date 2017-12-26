Rails.application.routes.draw do
  #トップページ
  root 'static_pages#home'
  #固定ページ
  get '/about', to: 'static_pages#about'

end
