Rails.application.routes.draw do
  resources :categories
  resources :users
  resources :photo_tag_references
  resources :photo_tags
  resources :photos
  resources :albums
  resources :sessions, only: [:new, :create, :destroy]
  get '/signin' => 'sessions#new'
  get '/signout' => 'sessions#destroy'
  
  post '/upload_photos' => 'albums#upload_photos'
  get '/upload_photos' => 'albums#upload_photos'
  
  get "/reset_filter" => 'photos#reset_filter'
  get '/edit_photos' => 'photos#edit_photos'
  get '/photos/:id/edit_slider_copy' => 'photos#edit_slider_copy'
  patch '/photos/:id/update_slider_copy' => 'photos#update_slider_copy'
  
  
  
  get '/index' => 'pages#index'
  get '/about' => 'pages#about'
  get '/switch_locale' => 'pages#switch_locale'
  root to: "pages#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
