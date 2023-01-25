Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  root 'index#landing_page'
  
  resources :index do
    collection do
      get 'landing_page'
      get 'hexmap'
    end
  end
  
  #get 'index/hexmap', to: 'index#hexmap'
  
  
end
