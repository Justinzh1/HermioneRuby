Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :home, :only => [:index]
  resource :courses
  root to: 'home#index'
end
