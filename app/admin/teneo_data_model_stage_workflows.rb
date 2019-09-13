ActiveAdmin.register Teneo::DataModel::StageWorkflow, as: 'StageWorkflow' do
  menu parent: 'Ingest tools', priority: 3

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

  form do |f|
    f.inputs do
      f.input :stage, required: true, collection: Teneo::DataModel::StageWorkflow::STAGE_LIST
      f.input :name
      f.input :description
      f.hidden_field :lock_version
    end
    actions
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
          column 'Parameter definitions' do |stage_task|
            table_for stage_task.task.parameter_defs do
              column :name

              column :export do |param_def|
                p = resource.parameters["#{stage_task.task.name}##{param_def.name}"]
                if p && p[:value].nil?
                  p[:name]
                end
              end
              column :default do |param_def|
                p = resource.parameters["#{stage_task.task.name}##{param_def.name}"]
                if p && p[:value].nil?
                  p[:default]
                end
              end
              column :value do |param_def|
                p = resource.parameters["#{stage_task.task.name}##{param_def.name}"]
                if p && p[:value]
                  p[:value]
                end
              end
            end
            # stage_task.task.parameter_defs.map { |param| "#{param.name}#{" (#{param.default})" if param.default}" }
          end
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_stage_workflow_stage_task_path(model.stage_workflow, model)
          end
        end
        new_button :stage_workflow, :stage_task
      end
      tab 'Parameters', class: 'panel_contents' do
        table_for stage_workflow.parameter_refs.order(:id) do
          column 'Export as' do |obj|
            obj.value ? '' : obj.name
          end
          column :description
          column :delegation, as: :tags
          column :default
          column :value
          column '' do |param_ref|
            # noinspection RubyResolve
            action_icons path: admin_stage_workflow_parameter_ref_path(stage_workflow, param_ref), actions: %i[edit delete]
            help_icon param_ref.help
          end
        end
        new_button :stage_workflow, :parameter_ref
      end
      tab 'Ingest Workflows', class: 'panel_contents' do
        table_for stage_workflow.ingest_workflows do
          column :name do |obj|
            # noinspection RubyResolve
            link_to obj.name, admin_ingest_agreement_ingest_workflow_path(obj.ingest_agreement, obj)
          end
        end
      end
    end
  end

end
