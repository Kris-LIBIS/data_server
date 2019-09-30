Rails.application.routes.draw do

  # GraphQL
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Grape API
  mount V1::API => '/api'
  mount GrapeSwaggerRails::Engine => '/api/doc'

  # JWT
  devise_for :login_users, path: '/api',
             path_names: {
                 sign_in: 'login',
                 sign_out: 'logout',
                 # registration: 'signup'
             },
             controllers: {
                 sessions: 'sessions',
                 # registrations: 'registrations'
             }

  # Active Admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  p_only = [:index, :show, :new, :edit, :destroy, :create, :update]
  namespace :admin do
    # noinspection RailsParamDefResolve
    resources :converters, only: [] do
      resources :parameters, only: p_only
    end
    # noinspection RailsParamDefResolve
    resources :tasks, only: [] do
      resources :parameters, only: p_only
    end
    # noinspection RailsParamDefResolve
    resources :storage_types, only: [] do
      resources :parameters, only: p_only
    end
    # noinspection RailsParamDefResolve
    resources :conversion_tasks, only: [] do
      resources :parameters, only: p_only
    end
    # noinspection RailsParamDefResolve
    resources :stage_workflows, only: [] do
      resources :parameters, only: p_only
    end
    # noinspection RailsParamDefResolve
    resources :ingest_workflows, only: [] do
      resources :parameters, only: p_only
    end
    # noinspection RailsParamDefResolve
    resources :packages, only: [] do
      resources :parameters, only: p_only
    end
    # noinspection RailsParamDefResolve
    resources :storages, only: [] do
      resources :parameters, only: p_only
    end
  end

  root to: 'admin/dashboard#index'

end
