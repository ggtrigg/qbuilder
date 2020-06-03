Rails.application.routes.draw do
  devise_for :users
  root 'questionnaires#index'
  resources :questionnaires do
    resources :questions do
      collection do
        patch :sort
      end
    end
    resources :responses, except: [:edit, :update]
  end
  get 'thankyou', to: 'questionnaires#thankyou'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
