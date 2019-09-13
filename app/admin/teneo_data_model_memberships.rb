# frozen_string_literal: true
ActiveAdmin.register Teneo::DataModel::Membership, as: 'Membership' do
  menu false

  actions :index

  # config.sort_order = 'organization_asc'
  config.batch_actions = false

  permit_params :role, :user_id, :organization_id, :lock_version

  filter :organization
  filter :user
  filter :role

  index do
    column :organization
    column :user
    column :role
  end

end
