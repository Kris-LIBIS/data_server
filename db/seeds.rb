# frozen_string_literal: true
require 'teneo-data_model'
#require 'teneo-ingester'

ON_TTY=true

AdminUser.update_or_create({email: 'admin@example.com'}, {password: 'password', password_confirmation: 'password'}) if Rails.env.development?
AdminUser.update_or_create({email: 'teneo.libis@gmail.com'}, {password: 'abc123', password_confirmation: 'abc123'})
