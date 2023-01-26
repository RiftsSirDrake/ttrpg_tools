Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  root 'index#hexmap'
  
  resources :index do
    collection do
      get 'system_details'
      get 'hexmap'
    end
  end
  
  #get 'index/hexmap', to: 'index#hexmap'
  
  
end
