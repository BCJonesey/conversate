Conversate::Application.routes.draw do
  root :to => 'home#index'

  get 'admin' => 'admin#index', :as => 'admin'
  resource :users, :only => [:new, :create, :update]
  resource :session, :only => [:new, :create]
  get 'session/logout' => 'sessions#destroy', :as => 'destroy_sessions'

  get 'conversation/:slug/:id(#message:message_id)' => 'conversations#show',
    :as => 'conversation'
  get 'topic/:slug/:id' => 'topics#show', :as => 'topic'

  get 'ux/testbed' => 'testbed#index'
  get 'ux/testbed/:view' => 'testbed#test_view', :as  =>'test_view'

  get 'profile' => 'users#edit'

  get 'people' => 'groups#index'
  put 'people' => 'groups#edit'
  post 'people' => 'groups#new_user'

  namespace :api do
    namespace :v0 do
      resources :topics, :only => [:index, :create] do
        resources :conversations, :only => [:index, :create]
      end
      resources :conversations, :only => [:show] do
        resources :actions, :only => [:index, :create]
        resources :participants, :only => [:index, :create, :destroy, :update]
      end
      resources :users, :only => [:index, :create, :update]
      resources :admin, :only => [:index]
    end
  end

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
