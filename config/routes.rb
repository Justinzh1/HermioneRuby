Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :home, :only => [:index]
  resource :courses
  root to: 'home#index'

  get 'box', :to => 'box#index', :as => 'box'
  get 'box/auth', :to => 'box#auth', :as => 'box_auth'
  get 'box/dashboard', :to => 'box#dashboard', :as => 'box_dashboard'
  get 'box/download/:id', :to => 'box#download', :as => 'box_download'
  post 'box/upload', :to => 'box#upload', :as => 'box_upload'

  get 'youtube', :to => 'youtube#index', :as => 'youtube'
  post 'youtube/upload', :to => 'youtube#upload', :as => 'youtube_upload'
end
