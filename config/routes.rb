Rails.application.routes.draw do
  devise_for :users
  root 'questionnaires#landing'
  resources :questionnaires do
    resources :questions do
      collection do
        patch :sort
      end
    end
    resources :responses, except: [:edit, :update]
  end
  get 'thankyou/(:id)', to: 'questionnaires#thankyou', as: :thankyou
  get '/(:questionnaire_id)', to: 'responses#new', as: :new_response
  scope "/admin" do
    resources :users, only: [:index, :destroy]
    get 'become/(:id)', to: 'users#become', as: :become_user
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
