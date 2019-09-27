# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::IngestAgreement, as: 'IngestAgreement' do

  belongs_to :organization, parent_class: Teneo::DataModel::Organization
  # navigation_menu :organization

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :project_name, :collection_name,
                :collection_description, :ingest_workflow_name,
                :organization_id, :producer_id, :material_flow_id,
                :contact_ingest_list, :contact_collection_list, :contact_system_list,
                :lock_version

  filter :name
  filter :organization
  filter :collection_name

  index do
    back_button
    column :name do |agreement|
      auto_link agreement
    end
    column :organization
    column :project_name
    column :collection_name
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: [:delete]
    end

  end

  show do
    back_button

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
      row :ingest_workflow_name
      row :project_name
      row :collection_name
      row :collection_description
      row :ingest_workflow_name
      row :producer
      row :material_flow
    end

    tabs do
      tab 'Ingest Workflows', class: 'panel_contents' do

        table_for ingest_agreement.ingest_workflows do
          column :name do |workflow|
            auto_link workflow
          end
          # noinspection RubyResolve
          list_column :tasks do |workflow|
            workflow.ingest_stages.inject({}) { |hash, stage| hash[stage.stage] = auto_link(stage.stage_workflow); hash }
          end
          # # noinspection RubyResolve
          # list_column :parameters do |workflow|
          #   workflow.parameter_values
          # end
          column '' do |workflow|
            # noinspection RubyResolve
            action_icons path: admin_ingest_agreement_ingest_workflow_path(workflow.ingest_agreement, workflow), actions: [:delete]
          end
        end
        new_button :ingest_agreement, :ingest_workflow

      end

      tab 'Ingest Models', class: 'panel_contents' do
        table_for ingest_agreement.ingest_models do
          column :name do |model|
            auto_link model
          end
          # noinspection RubyResolve
          list_column :representations do |model|
            model.representations.map {|x| auto_link x}
          end
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_ingest_agreement_ingest_model_path(model.ingest_agreement, model), actions: [:delete]
          end
        end
        new_button :ingest_agreement, :ingest_model
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
      f.input :ingest_run_name
      f.input :producer, as: :select, collection: Teneo::DataModel::Producer.for_organization(resource.organization).all
      f.input :material_flow, as: :select, collection: Teneo::DataModel::MaterialFlow.for_organization(resource.organization).all
      f.hidden_field :lock_version
    end
    actions
  end

end
