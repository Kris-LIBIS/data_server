# frozen_string_literal: true
require 'action_icons'
require 'nested_action_icons'

ActiveAdmin.register Teneo::DataModel::Organization, as: 'Organization' do
  menu priority: 2

  config.sort_order = 'name_asc'
  config.batch_actions = false

  filter :name
  filter :description
  filter :inst_code

  permit_params :name, :description, :inst_code, :ingest_dir, :lock_version,
                memberships_attributes: [:id, :_destroy, :organization_id, :role_id, :user_id],
                storages_attributes: [:id, :_destroy, :organization_id, :name, :protocol, :options],
                ingest_agreements_attributes: [:id, :_destroy, :organization_id, :name]

  index do
    column :name
    column :description
    column :inst_code
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object)
    end
  end

  show do

    attributes_table do
      row :name
      row :description
      row :inst_code
      row :ingest_dir
    end

    tabs do

      tab 'Users', class: 'panel_contents' do

        table_for organization.memberships do
          column 'Name', :user
          column :role
          column '' do |membership|
            # noinspection RubyResolve
            action_icons path: resource_path(membership) # FIXME
          end
        end

      end

      tab 'Storages', class: 'panel_contents' do

        table_for organization.storages do
          column :name
          column :protocol
          column '' do |storage|
            # noinspection RubyResolve
            action_icons path: admin_organization_storage_path(storage.organization, storage)
          end
        end
        # end

      end

      tab 'Ingest Agreements', class: 'panel_contents' do
        # noinspection RubyResolve
        # panel 'Ingest Agreements' do
        table_for organization.ingest_agreements do
          column :name
        end
        # end

      end

    end


  end

  form do |f|
    f.inputs 'Info' do
      f.input :name, required: true
      f.input :description
      f.input :inst_code, required: true
      f.input :ingest_dir
    end
    actions
  end


end
