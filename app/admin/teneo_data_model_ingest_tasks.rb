#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::IngestTask, as: 'IngestTask' do

  belongs_to :ingest_workflow, parent_class: Teneo::DataModel::IngestWorkflow

  config.batch_actions = false

  permit_params :stage, :autorun, :ingest_workflow_id, :stage_workflow_id, :lock_version

  filter :stage

  index do
    back_button
    column :stage
    # noinspection RubyResolve
    toggle_bool_column :autorun
    column :stage_workflow
    column 'Parameters' do |task|
      task.parameter_values.map {|value| "#{value.name}='#{value.value}'"}
    end
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[view delete]
    end
  end

  show do
    back_button
    attributes_table do
      row :stage, as: :select, collection: Teneo::DataModel::IngestTask::STAGE_LIST

      row :stage_workflow
    end
  end

  form do |f|
    f.inputs 'Info' do
      f.input :stage, required: true, as: :select, collection: Teneo::DataModel::IngestTask::STAGE_LIST
      f.input :stage_workflow, as: :select, collection: Teneo::DataModel::StageWorkflow.where(stage: resource.stage)
      f.hidden_field :lock_version
    end
    actions
  end

end
