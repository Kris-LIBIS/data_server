Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Grape API
  mount V1::API => '/'
  mount GrapeSwaggerRails::Engine => '/api/swagger'
end
