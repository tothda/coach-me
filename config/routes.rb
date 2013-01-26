CoachMe::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => "registrations"}
  
  resources :users do
    resources :trainings do
      resources :exercises
    end
  end
  
  resources :trainings do
    resources :exercises
  end

  resources :relationships
  
  root :to => 'trainings#index'
end

