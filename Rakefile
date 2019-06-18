# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :db do

  desc 'Kill open DB connections'
  task kill_connections: :environment do
    db_name = Rails.configuration.database_configuration[Rails.env]['database']
    `psql -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='#{db_name}' AND pid <> pg_backend_pid();" -d '#{db_name}'`
    puts 'Database connections closed.'
  end

  task drop: :kill_connections

  desc 'reset with new schema'
  task recreate: [:drop, :create, :migrate, :seed]

  desc "Truncate all existing data"
  task :truncate => "db:load_config" do
    DatabaseCleaner.clean_with :truncation
  end

end