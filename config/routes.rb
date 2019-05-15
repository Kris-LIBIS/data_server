Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Grape API
  mount Versions::V1::API => '/'
  mount GrapeSwaggerRails::Engine => '/api/doc'
end
