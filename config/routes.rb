Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :home, :only => [:index]
  resource :courses do
    resources :semesters do
      resources :lectures do
        resources :videos 
      end
    end
  end
  post 'courses/create', :to => 'courses#create', :as => 'course_create'
  get 'courses', :to => 'courses#index', :as => 'courses_all'

  root to: 'home#index'

  # TODO replace
  get 'box', :to => 'box#index', :as => 'box'
  # get 'box/auth', :to => 'box#auth', :as => 'box_auth'
  get 'box/dashboard', :to => 'box#dashboard', :as => 'box_dashboard'
  get 'box/download/:id', :to => 'box#download', :as => 'box_download'
  post 'box/upload', :to => 'box#upload', :as => 'box_upload'

  get 'drive', :to => 'drive#index', :as => 'drive'  

  get 'youtube', :to => 'youtube#index', :as => 'youtube'
  post 'youtube/upload', :to => 'youtube#upload', :as => 'youtube_upload'

  get 'process', :to => 'videos#index', :as => 'process'
  post 'process', :to => 'videos#upload', :as => 'process_upload'
end
