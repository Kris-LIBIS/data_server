#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::IngestAgreement, as: 'IngestAgreement' do
  menu priority: 3

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :project_name, :collection_name,
                :collection_description, :ingest_job_name,
                :producer_id, :material_flow_id, :organization_id,
                :contact_ingest_list, :contact_collection_list, :contact_system_list,
                :lock_version

  filter :name
  filter :organization
  filter :collection_name

  index do
    column :name
    column :organization
    column :project_name
    column :collection_name
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object)
    end
  end

  show do
    tabs do
      tab 'Info' do
        # noinspection RubyResolve
        attributes_table do
          row :name
          row :organization
          row :ingest_job_name
          row :mime_types
          row :puids
          row :project_name
          row :collection_name
          row :collection_description
          row :ingest_model
          h2 'Contacts:'
          row 'Ingest', as: :tags do
            resource.contact_ingest_list
          end
          row 'Collection', as: :tags do
            resource.contact_collection_list
          end
          row 'System', as: :tags do
            resource.contact_system_list
          end
        end
      end
      tab 'Ingest Jobs' do

      end
      tab 'Packages' do

      end
    end
  end

  form do |f|
    f.inputs 'Ingest Agreement info' do
      f.input :name, required: true
      f.input :organization, required: true
      f.input :ingest_job_name
      f.input :project_name
      f.input :collection_name
      f.input :collection_description
      f.input :contact_ingest_list, as: :tags
      f.input :contact_collection_list, as: :tags
      f.input :contact_system_list, as: :tags
      f.hidden_field :lock_version
    end
    actions
  end

end
