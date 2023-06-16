Rails.application.routes.draw do
  post '/login', to: 'authentication#login'
  
  resources :users, except: [:new, :edit] do
    resources :posts, except: [:new, :edit]
  end
  
  resources :comments
end
