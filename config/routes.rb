Spree::Core::Engine.routes.draw do
  namespace :admin do
    get '/search/addresses', :to => 'search#addresses', :as => :search_addresses
  end
end