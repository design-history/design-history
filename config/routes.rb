Rails.application.routes.draw do
  scope via: :all do
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
    get "/500", to: "errors#internal_server_error"
  end

  constraints domain: Rails.application.config.admin_domain do
    root to: "pages#landing"

    get "/start", to: "pages#start"

    devise_for :users

    resources :projects do
      get "/manage-access", to: "manage_access#edit"
      patch "/manage-access", to: "manage_access#update"

      resources :posts do
        resources :images,
                  only: %i[create destroy],
                  controller: "post_images" do
          post :up, on: :member
          post :down, on: :member
        end
      end
    end
  end

  constraints subdomain: "www", domain: Rails.application.config.app_domain do
    get "/(:any)",
        to: redirect(host: Rails.application.config.admin_domain, path: "")
  end

  constraints domain: Rails.application.config.app_domain do
    get "/", to: "app#index", as: "app_posts"
    get "/:post_id", to: "app#show", as: "app_post"
  end
end
