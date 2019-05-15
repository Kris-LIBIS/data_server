Rails.application.routes.draw do
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

end
