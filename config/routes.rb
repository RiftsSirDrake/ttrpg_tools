Rails.application.routes.draw do
  root 'index#landing_page'
  devise_for :users

  # Should move hexmap stuff into its own controller and use index as main landing pages... thinking about future expansion and such
  # Example single route for my goldfish like memory: get 'index/hexmap', to: 'index#hexmap'
  resources :index do
    collection do
      get 'landing_page'
    end
  end

  resources :hex_system do
    collection do
      get 'hexmap'
    end
  end

  resources :sectors, controller:'sector/sectors'
  resources :systems, controller:'sector/systems' do
    collection do
      get 'bulk_upload'
      post 'process_bulk_upload'
    end
  end
  resources :factions, controller:'sector/factions'
  resources :system_notes, controller:'sector/system_notes'

end
