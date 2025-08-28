Rails.application.routes.draw do
  resource :session, except: [:show, :edit, :update]
  resources :passwords, param: :token
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
  
  resources :clientes do
    resources :vehiculos, except: [:index]
  end
  
  resources :vehiculos, only: [:index, :show, :edit, :update, :destroy, :new, :create]
  resources :users
  resources :proveedores
  resources :productos
  resources :servicios
  resources :facturas do
    member do
      patch :marcar_como_pagada
      patch :anular
    end
    collection do
      get :desde_servicios
      post :crear_desde_servicio
    end
    resources :detalles_facturas, path: 'detalles'
  end
  resources :pedidos
  
  resources :detalles_servicio_vehiculos do
    member do
      patch :cerrar_servicio
      get :cerrar_servicio  # Agregar ruta GET como fallback
    end
    
    resources :detalles_servicio_productos, except: [:show] do
      collection do
        post :finalizar_servicio
      end
    end
  end
end
