Rails.application.routes.draw do
  

  devise_for :users, :controllers => { registration: 'registrations' }

  root :to => "profile#show"
#match "/entrees/new/:id", :to => "entrees#new", :as => 'new_entrees'

  get "/profile/all"
  get "/event/search_friend"
  get "/event/new_participant"
  post 'event/:id/transaction_settle/:transaction_id', :to => 'event#transaction_settle', :as => 'transaction_settle'
  get 'event/:id/transaction_remind/:transaction_id', :to => 'event#transaction_remind', :as => 'transaction_remind'
  get 'profile/notification_read/:notification_id', :to => 'profile#notification_read', :as => 'notification_read'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :event do 
    #get ':aa/with_user'
  end
  resources :profile, only: [:show, :index]
  resources :friendships

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
