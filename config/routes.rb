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
  get 'thankyou', to: 'questionnaires#thankyou'
  scope "/admin" do
    resources :users, only: [:index, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
