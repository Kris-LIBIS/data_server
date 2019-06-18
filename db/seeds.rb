# frozen_string_literal: true
require 'teneo-data_model'

# dir = File.join Teneo::DataModel.root, 'db', 'seeds'
# Teneo::DataModel::SeedLoader.new(dir)

dir = File.join Rails.root, 'db', 'seeds'
Teneo::DataModel::SeedLoader.new(dir)

LoginUser.create(email: 'admin@libis.be', password: 'abc123')
LoginUser.create(email: 'teneo@libis.be', password: '123abc')

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
AdminUser.create!(email: 'teneo.libis@gmail.com', password: 'abc123', password_confirmation: 'abc123')
