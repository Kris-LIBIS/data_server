# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo| "https://github.com/#{repo}.git" }

gem 'dotenv-rails'#, groups: [:development, :test]

gem 'rails', '~> 5.2.3'
gem 'rack-cors'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'database_cleaner'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry-rails'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'therubyracer'

gem 'normalize-rails'

# import DataModel
gem 'teneo-data_model', '~> 0.2'

gem 'tty-prompt'
gem 'tty-spinner'

# Grape API
gem 'grape'
gem 'hashie-forbidden_attributes'
gem 'grape-jbuilder'
gem 'grape_on_rails_routes'
gem 'swagger-ui_rails'
gem 'grape-swagger'
gem 'grape-swagger-rails'

# JWT authentication
gem 'devise-jwt'

# GraphQL
gem 'graphql', '1.8.13'
gem 'graphiql-rails', '1.5.0', group: :development

# Admin
gem 'activeadmin', github: 'activeadmin/activeadmin'#, branch: 'fix_renamed_resources_and_optional_belongs_to'
gem 'activeadmin_addons'
gem 'activeadmin_json_editor'
gem 'activeadmin_reorderable'
# gem 'activeadmin_simplemde', github: 'parti-coop/activeadmin_simplemde'
gem 'active_admin-markdown_editor'

gem 'active_admin_theme'
# gem 'arctic_admin'
# gem "active_material", github: "vigetlabs/active_material"
# gem 'active_admin_flat_skin'
# gem 'responsive_active_admin'

gem 'font_awesome5_rails'

gem 'sass-rails'

gem 'teneo-ingester'

# Better errors
group :development do
  gem "better_errors"
  gem "binding_of_caller"
end