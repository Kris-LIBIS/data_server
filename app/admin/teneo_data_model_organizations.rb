# frozen_string_literal: true
require 'action_icons'

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

    columns do
      column span: 2 do

        attributes_table do
          row :name
          row :description
          row :inst_code
          row :ingest_dir
        end
      end
      column do
        # noinspection RubyResolve
        panel 'Users' do
          table_for organization.memberships do
            column :user
            column :role
          end
        end
      end
    end

    tabs do

      tab 'Storages', class: 'panel_contents' do

        table_for organization.storages do
          column :name
          column :protocol
          column '' do |storage|
            # noinspection RubyResolve
            action_icons path: admin_organization_storage_path(storage.organization, storage)
          end
        end
        new_button :organization, :storage

      end

      tab 'Ingest Agreements', class: 'panel_contents' do
        table_for organization.ingest_agreements do
          column :name
          column '' do |agreement|
            # noinspection RubyResolve
            action_icons path: admin_organization_ingest_agreement_path(agreement.organization, agreement)
          end
        end
        new_button(:organization, :ingest_agreement)

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
