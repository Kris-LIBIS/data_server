ActiveAdmin.register Teneo::DataModel::StageTask, as: 'StageTask' do
  # noinspection RailsParamDefResolve
  belongs_to :stage_workflow, parent_class: Teneo::DataModel::StageWorkflow

  config.batch_actions = false

  permit_params :position, :stage_workflow_id, :task_id, :lock_version

  filter :stage_workflow
  filter :description

  index do
    column :position
    column :stage_workflow
    column :task
  end

end
