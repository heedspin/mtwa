Smtcoinc::Application.routes.draw do
  resources :s3_uploads

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  match 'login' => 'user_sessions#new', :as => 'login'
  match 'logout' => 'user_sessions#destroy', :as => 'logout'
  resource :user_session, :only => [ :new, :create, :destroy ]

  resources :users do
    member do
      get 'delete'
    end
    resource :activation do
      member do
        get 'delete'
      end
    end
    resource :password, :only => [ :edit, :update ]
  end
  
  resources :user_verifications, :only => [ :show ]
  resources :password_resets
  resources :news, :as => :news_items, :controller => :news_items do
    member do
      get 'move'
    end
    collection do
      get 'fix_positions'
    end
  end
  match 'quote_requests/thanks' => 'quote_requests#thanks', :as => 'quote_request_thanks'
  resources :quote_requests
  resources :content_modules
  
  resources :mt_pdf_surveys

  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
