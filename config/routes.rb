ActionController::Routing::Routes.draw do |map|
  map.resources :categories


  map.root :controller => "home"

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
  map.login      '/login', :controller => 'home', :action => 'login'
  map.logout     '/logout', :controller => 'home', :action => 'logout'
  map.register   '/register', :controller => 'home', :action => 'register'
  map.directions '/directions', :controller => 'home', :action => 'directions'
  map.videos     '/videos', :controller => 'home', :action => 'videos'
  map.track      '/track', :controller => 'application', :action => 'track'

  #RESTful routes
  map.resources :headlines, :has_many => :comments, :shallow => true
  map.resources :open_dates, :tickets, :links, :abouts, :contacts
  map.resources :photos, :except => [:show, :edit, :update]

  map.connect 'photos/gallery/:category', :controller => 'photos', :action => 'gallery'
  map.connect 'photos/:category', :controller => 'photos', :action => 'index'

  #email routes
  map.connect 'email_opt_out/:id', :controller => 'home', :action => 'email_opt_out'
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # See how all your routes lay out with "rake routes"
end
