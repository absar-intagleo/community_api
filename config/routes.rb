Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: :create do
  	collection do 
  		post :login
  		post :logout
  		get :members
  	end
  end

  resources :conversations, only: [:index, :create] do
  	collection do
  		post :mark_read
  		post :archive
  	end
  end
  resources :messages, only: [:index, :create] do
  	collection do
  		post :mark_read
  	end
  end
end
