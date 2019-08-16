ActiveAdmin.register Teneo::DataModel::StageWorkflow, as: 'StageWorkflow' do
  menu parent: 'Ingest tools', priority: 5

  config.sort_order = 'stage_asc'
  config.batch_actions = false

  permit_params :stage, :name, :description, :lock_version

  filter :name
  filter :description

  scope :all, default: true
  Teneo::DataModel::Task::STAGE_LIST.each do |stage|
    scope stage, group: :stage do |stage_workflows|
      stage_workflows.where(stage: stage)
    end
  end

  index do
    column :stage
    column :name
    column :description
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object)
    end
  end

  show do
    attributes_table do
      row :stage
      row :name
      row :description
    end

    tabs do
      tab 'Stage workflow tasks', class: 'panel_contents' do
        # noinspection RubyResolve
        reorderable_table_for stage_workflow.stage_tasks do
          column :task
          # noinspection RubyResolve
          list_column 'Parameter values' do |stage_task|
            stage_task.parameter_values.inject({}) { |hash, value| hash[value.name] = value.value; hash }
          end
          # noinspection RubyResolve
          list_column 'Parameter definitions' do |stage_task|
            stage_task.task.parameter_defs.map { |param| "#{param.name}#{" (#{param.default})" if param.default}" }
          end
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_stage_workflow_stage_task_path(model.stage_workflow, model)
          end
        end
        new_button :stage_workflow, :stage_task
      end
      tab 'Parameter references', class: 'panel_contents' do
        table_for stage_workflow.parameter_refs.order(:id) do
          column :name
          column :description
          column :delegation, as: :tags
          column :default
          column '' do |param_ref|
            # noinspection RubyResolve
            action_icons path: admin_stage_workflow_parameter_ref_path(stage_workflow, param_ref), actions: %i[edit delete]
            help_icon param_ref.help
          end
        end
        new_button :stage_workflow, :parameter_ref
      end
    end
  end

end