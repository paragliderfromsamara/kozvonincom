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
  
  #get '/404' => 'pages#err_404'
  
  get '/index' => 'pages#index'
  get '/about' => 'pages#about'
  get '/switch_locale' => 'pages#switch_locale'
  get '/please_wait' => 'pages#please_wait'
  
  root to: "pages#index"
  get '*unmatched_route', to: 'pages#err_404'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
