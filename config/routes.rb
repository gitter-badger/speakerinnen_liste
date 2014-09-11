SpeakerinnenListe::Application.routes.draw do

  scope '(:locale)', locale: /en|de/ do

    # route post to /tags/merge to here
    namespace :admin do
      resources :tags, except: [:new, :create] do
        collection do
          get 'categorization'
        end
        member do
          post 'set_category'
          post 'remove_category'
        end
      end
      resources :categories
      resources :profiles do
        resources :medialinks
        member do
          post 'publish'
          post 'unpublish'
          post 'admin_comment'
        end
      end
      root to: 'dashboard#index'
    end

    devise_for :profiles, controllers: {omniauth_callbacks: 'omniauth_callbacks'}

    get 'topics/:topic', to: 'profiles#index', as: :topic

    get 'search' => 'search#search'

    get  'contact' => 'contact#new',    as: 'contact'
    post 'contact' => 'contact#create'

    get 'impressum' => 'pages#impressum'
    get 'about' => 'pages#about'
    get 'links' => 'pages#links'
    get 'faq' => 'pages#faq'
    get 'press' => 'pages#press'

    get '/', to: 'pages#home'

    get 'categories/:category_id', to: 'profiles#category', as: :category

    resources :profiles, except: [:new, :create] do
      resources :medialinks
        get  'contact' => 'contact#new', as: 'contact', on: :member
        post 'contact' => 'contact#create', on: :member

      resources :medialinks do
       collection { post :sort }
      end
    end

    devise_scope :profile do
      get 'sign_up' => 'devise/registrations#new'
    end

    #get 'sign_up' => 'profiles#new'
    constraints(host: /^(speakerinnen-liste.herokuapp.com|speakerinnen.org)$/) do
      root to: redirect('http://www.speakerinnen.org')
      # match '/*path', to: redirect {|params| "http://www.example.com/#{params[:path]}"}
    end
  end
end
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
