Conversate::Application.routes.draw do
  # The docs say that the root matcher here only grabs GET, but I swear it was
  # eating my POSTs too.
  get '/' => 'home#index', :as => 'root'
  post '/' => 'home#beta_signup', :as => 'beta_signup'

  get '/tour' => 'marketing#tour', :as => 'tour'
  get '/about' => 'marketing#about', :as => 'about'

  get 'admin' => 'admin#index', :as => 'admin'
  post 'admin/promote/:id' => 'admin#promote', :as => 'promotion'
  post 'admin/remove_from_beta/:id' => 'admin#remove_from_beta', :as => 'remove_from_beta'
  resource :users, :only => [:update]
  resource :session, :only => [:create]
  get 'session/logout' => 'sessions#destroy', :as => 'destroy_sessions'

  get 'conversation/:slug/:id' => 'conversations#show',
    :as => 'conversation'
  get 'folder/:slug/:id' => 'folders#show', :as => 'folder'

  get 'ux/testbed' => 'testbed#index', :as => 'testbed'
  get 'ux/testbed/:view' => 'testbed#test_view', :as  =>'test_view'

  get 'profile' => 'users#edit'

  get '/people' => 'contacts#index'
  get '/people/contact-lists/:id' => 'contacts#show_list'

  resources :password_resets
  resources :account_activations, :only => [:edit, :update]

  namespace :api do
    namespace :v0 do
      concern :participatable do
        resources :participants, controller: 'participants_concern'
      end
      resources :folders, :only => [:index, :create, :update, :destroy] do
        post 'users', :on => :member
        resources :conversations, :only => [:index, :create]
      end
      resources :conversations, :only => [:show] do
        get 'unread_count', on: :collection
        get 'unread', on: :collection
        resources :actions, :only => [:index, :create]
        resources :participants, :only => [:index, :create, :destroy, :update]
      end
      resources :users, :only => [:index, :create, :update] do
        get 'lookup', :on => :collection
        get 'contact_lists', :on => :member
      end
      resources :admin, :only => [:index]
      resources :files, :only => [:create]
      resources :search, :only => [:index]
      resources :contact_lists, concerns: :participatable do
        resources :contacts
      end
      resources :invite, :only => [:create]
      resources :device_api_key, :only => [:create]
    end
  end

  namespace :webhooks do
    namespace :v0 do
      post 'email/mandrill' => 'email#mandrill_inbound'
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
