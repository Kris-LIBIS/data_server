#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::StageTask, as: 'StageTask' do

  belongs_to :stage_workflow, parent_class: Teneo::DataModel::StageWorkflow
  reorderable

  config.sort_order = 'position_asc'
  config.batch_actions = false
  config.filters = false

  permit_params :position, :stage_workflow_id, :task_id, :lock_version

  index as: :reorderable_table do
    back_button
    column :task
    # noinspection RubyResolve
    list_column 'Parameters' do |task|
      task.parameter_values.inject({}) { |hash, value| hash[value.name] = value.value; hash }
    end
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[view delete]
    end
  end

  show do
    back_button
    attributes_table do
      row :task
    end
    tabs do
      tab 'Parameters', class: 'panel_contents' do
        table_for resource.parameter_values.order(:id) do
          column :name
          column :value
          column '' do |param_value|
            # noinspection RubyResolve
            action_icons path: admin_stage_task_parameter_value_path(resource, param_value), actions: %i[edit delete]
          end
        end
        new_button :stage_task, :parameter_value
      end
    end
  end

  form do |f|
    f.inputs 'Info' do
      f.input :task, required: true, as: :select, collection: Teneo::DataModel::Task.where(stage: stage_task.stage_workflow.stage)
      f.hidden_field :lock_version
    end
    actions
  end

end
