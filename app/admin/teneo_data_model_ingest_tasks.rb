#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::IngestTask, as: 'IngestTask' do

  belongs_to :ingest_job, parent_class: Teneo::DataModel::IngestJob

  config.batch_actions = false

  permit_params :stage, :ingest_job_id, :workflow_id, :lock_version

  filter :stage

  index do
    back_button
    column :stage
    column :workflow
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
      row :workflow
    end
  end

  form do |f|
    f.inputs 'Info' do
      f.input :stage, required: true, as: :select, collection: Teneo::DataModel::IngestTask::STAGE_LIST
      f.input :workflow, as: :select, collection: Teneo::DataModel::Workflow.where(stage: resource.stage)
      f.hidden_field :lock_version
    end
    actions
  end

end
