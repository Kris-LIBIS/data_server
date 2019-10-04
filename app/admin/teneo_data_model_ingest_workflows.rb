# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::IngestWorkflow, as: 'IngestWorkflow' do

  # noinspection RailsParamDefResolve
  belongs_to :ingest_agreement, parent_class: Teneo::DataModel::IngestAgreement

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :description, :ingest_agreement_id, :lock_version

  filter :name
  filter :description

  index do
    back_button
    column :name
    column :description
    actions defaults: false do |obj|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(obj), actions: %i[view delete]
    end
  end

  show do
    back_button

    attributes_table do
      row :name
      row :description
    end

    tabs do

      tab 'Ingest Stages', class: 'panel_contents' do
        table_for ingest_workflow.ingest_stages do
          column :stage
          # noinspection RubyResolve
          toggle_bool_column :autorun
          column :stage_workflow
          # noinspection RubyResolve
          list_column 'Parameters' do |stage|
            list_for parent_resource: ingest_workflow, resource: stage.stage_workflow
          end
          column '' do |stage|
            # noinspection RubyResolve
            action_icons path: admin_ingest_workflow_ingest_stage_path(stage.ingest_workflow, stage)
          end
        end
        new_button :ingest_workflow, :ingest_stage
      end

      tab 'Parameters', class: 'panel_contents' do
        # noinspection RubyResolve
        parameter_tab resource: ingest_workflow,
                      message: "The parameters configure the stage workflows. The following parameters can be referenced:"
      end

      tab 'Packages', class: 'panel_contents' do
        table_for ingest_workflow.packages.order(:created_at) do
          column :name do |package|
            auto_link package
          end
          # noinspection RubyResolve
          list_column :runs do |package|
            package.runs.map {|x| auto_link x}
          end
          column '' do |package|
            # noinspection RubyResolve
            action_icons path: admin_ingest_workflow_package_path(package.ingest_workdflow, package), actions: [:delete]
          end
        end
      end
    end
  end

  form do |f|
    f.inputs 'Info' do
      f.input :name, required: true
      f.input :description
      f.hidden_field :lock_version
    end
    actions
  end

end
