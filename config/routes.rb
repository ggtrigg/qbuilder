Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  root "questionnaires#landing"
  resources :questionnaires do
    resources :questions
    resources :responses, except: [ :edit, :update ]
  end

  get "/questionnaires/other/(:uid)", to: "questionnaires#index_other", as: :questionnaires_uid

  scope "/admin" do
    resources :users, only: [ :index, :destroy ]
    get "become/(:id)", to: "users#become", as: :become_user
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  ####
  # Custom routes start here
  #
  # For each new custom route:
  #
  # * Be sure you have the canonical route declared above
  # * Add the new custom route below the existing ones
  # * Document why it's needed
  # * Explain anything else non-standard

  # Shorter URL (public facing) for a new response.
  get "/(:questionnaire_id)", to: redirect("/questionnaires/%{questionnaire_id}/responses/new"), as: :new_response
end
