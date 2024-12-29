Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  root "questionnaires#landing"
  resources :questionnaires do
    resources :questions
    resources :responses, except: [ :edit, :update ]
  end
  get "/questionnaires/other/(:uid)", to: "questionnaires#index_other", as: :questionnaires_uid
  get "thankyou/(:id)", to: "questionnaires#thankyou", as: :thankyou
  get "/verify_email", action: :verify_email, controller: :responses, as: :verify_email
  get "/(:questionnaire_id)", to: "responses#new", as: :new_response
  scope "/admin" do
    resources :users, only: [ :index, :destroy ]
    get "become/(:id)", to: "users#become", as: :become_user
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
