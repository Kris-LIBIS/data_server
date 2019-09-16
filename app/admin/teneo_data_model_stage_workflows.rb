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
          list_column 'Parameters' do |stage_task|
            stage_task.stage_workflow.parameter_values.each_with_object(Hash.new {|h,k|h[k]={}}) {|(k,v),result|
              next unless k =~ /^#{stage_task.task.name}#(.*)$/
              result[$1] = v
            }
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
          column :delegation, as: :tags do |param|
            param.delegation.split(/[\s,;]+/)
          end
          column 'Export as' do |param|
            param.name if param.export
          end
          column :description
          column :default
          column '' do |param_ref|
            help_icon param_ref.help
            # noinspection RubyResolve
            action_icons path: admin_stage_workflow_parameter_ref_path(stage_workflow, param_ref), actions: %i[edit delete]
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
