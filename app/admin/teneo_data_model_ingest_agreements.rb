#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::IngestAgreement, as: 'IngestAgreement' do

  belongs_to :organization, parent_class: Teneo::DataModel::Organization
  navigation_menu :organization

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :project_name, :collection_name,
                :collection_description, :ingest_job_name,
                :organization_id, :producer_id, :material_flow_id,
                :contact_ingest_list, :contact_collection_list, :contact_system_list,
                :lock_version

                filter :name
  filter :organization
  filter :collection_name

  index do
    back_button :organization
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
    back_button :organization

    tabs do
      tab 'Info' do
        # noinspection RubyResolve
        attributes_table do
          row :name
          row :organization
          row 'Ingest contacts', as: :tags do
            # noinspection RubyResolve
            resource.contact_ingest_list
          end
          row 'Collection contacts', as: :tags do
            # noinspection RubyResolve
            resource.contact_collection_list
          end
          row 'System contacts', as: :tags do
            # noinspection RubyResolve
            resource.contact_system_list
          end
          row :ingest_job_name
          row :project_name
          row :collection_name
          row :collection_description
          row :ingest_job_name
          row :producer
          row :material_flow
        end
      end

      tab 'Ingest Models', class: 'panel_contents' do
        table_for ingest_agreement.ingest_models do
          column :name
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_ingest_agreement_ingest_model_path(model.ingest_agreement, model)
          end
        end
        new_button :ingest_agreement, :ingest_model
        # noinspection RubyResolve
        # button_link classes: 'right-align', icon: 'plus-circle', title: 'New', href: new_admin_ingest_agreement_ingest_model_path(resource)
      end

      tab 'Ingest Jobs', class: 'panel_contents' do

        table_for ingest_agreement.ingest_jobs do
          column :name
          column '' do |job|
            # noinspection RubyResolve
            action_icons path: admin_ingest_agreement_ingest_job_path(job.ingest_agreement, job)
          end
        end
        new_button :ingest_agreement, :ingest_job
        # noinspection RubyResolve
        button_link classes: 'right-align', icon: 'plus-circle', title: 'New', href: new_admin_ingest_agreement_ingest_job_path(resource)

      end
      tab 'Packages', class: 'panel_contents' do

        table_for ingest_agreement.packages do
          column :name
          column '' do |package|
            # noinspection RubyResolve
            action_icons path: admin_ingest_agreement_package_path(package.ingest_agreement, package)
          end
        end

      end
    end

  end

  form do |f|
    f.inputs 'Ingest Agreement info' do
      f.input :name, required: true
      f.input :organization, required: true
      f.input :project_name
      f.input :contact_ingest_list, as: :tags
      f.input :contact_collection_list, as: :tags
      f.input :contact_system_list, as: :tags
      f.input :collection_name
      f.input :collection_description
      f.input :ingest_job_name
      f.input :producer, as: :select, collection: Teneo::DataModel::Producer.for_organization(resource.organization).all
      f.input :material_flow, as: :select, collection: Teneo::DataModel::MaterialFlow.for_organization(resource.organization).all
      f.hidden_field :lock_version
    end
    actions
  end

end
