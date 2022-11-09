Rails.application.routes.draw do
  constraints domain: Rails.application.config.admin_domain do
    root to: "pages#start"

    devise_for :users

    resources :projects do
      resources :posts
    end
  end

  constraints domain: Rails.application.config.app_domain do
    get "/", to: "app#index", as: "app_posts"
    get "/:post_id", to: "app#show", as: "app_post"
  end

  scope via: :all do
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
    get "/500", to: "errors#internal_server_error"
  end
end
