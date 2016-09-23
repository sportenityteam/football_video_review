Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: 'users/sessions', :registrations => "users/registrations",:passwords => "users/passwords" }

  root 'welcome#index'
  resources :orders
  resources :order_steps

  resources :orders do
    resources :order_steps
  end
  resources :payments
  resources :reviews, :except => [:new,:index]
  get "/pending_reviews" => "reviews#pending_reviews" , as: :pending_reviews
  get "/review_order/:id" => "reviews#new", as: :review_order
  get "/my_reviews" => "reviews#index" , as: :my_reviews
  get "/my_profile" => "users#show" , as: :my_profile
  get "/my_orders" => "orders#my_orders" , as: :my_orders

  namespace :admin do
    resources :users
    get "/review_pending_approval" => "order#index", as: :pending_orders
    get "/review_order/:id" => "order#show", as: :review_order
    get "/reviewed_videos" => "order#reviewed_videos", as: :reviewed_videos
    get "/video_pending_approval" => "order#reviewed_by_reviewer", as: :reviewed_by_reviewer
    get "/approval_of_admin/:id" => "order#approval_of_admin", as: :approval_of_admin
    get "/review_details/:id" => "reviews#show", as: :review_details
    get "/list_of_orders/" => "order#list_of_orders" , as: :list_of_orders
    get "/order_details/:id" => "order#order_details", as: :order_details
    resources :reviews, :only => [:new, :create]
    resources :prices#, :only => [:index]
  end

  #change password
  get  'edit_change_password' => 'users#edit_change_password', :as => :user_change_password
  post  'change_password' => 'users#change_password', :as => :edit_change_password
  patch  'change_password' => 'users#change_password', :as => :change_password
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
