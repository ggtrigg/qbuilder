Rails.application.routes.draw do
  root 'questionnaires#index'
  resources :questionnaires do
    resources :questions
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
