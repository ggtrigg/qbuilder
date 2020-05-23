Rails.application.routes.draw do
  devise_for :users
  root 'questionnaires#index'
  resources :questionnaires do
    resources :questions
    resources :responses
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
