Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :home, :only => [:index]
  resource :courses
  root to: 'home#index'

  get 'box', :to => 'box#index', :as => 'box'
  get 'box/auth', :to => 'box#auth', :as => 'box_auth'

  get 'youtube', :to => 'youtube#index', :as => 'youtube'
  get 'youtube/auth', :to => 'youtube#auth', :as => 'youtube_auth'
  post 'youtube/upload', :to => 'youtube#upload', :as => 'youtube_upload'
end
