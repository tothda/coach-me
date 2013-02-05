CoachMe::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => 'sessions'}
  
  resources :users do
    resources :trainings do
      resources :exercises
    end
  end
  
  resources :trainings do
    resources :exercises
  end
  
  resources :exercises

  resources :relationships
  
  root :to => 'home#index'
end

