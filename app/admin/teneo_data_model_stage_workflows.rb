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
    column :referenced, class: 'button' do |obj|
      if obj.ingest_workflows.count > 0
        # noinspection RubyResolve
        button_link href: resource_path(obj, anchor: 'referenced-by'), title: obj.ingest_workflows.count
      end
    end
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

      tab 'Tasks', class: 'panel_contents' do
        # noinspection RubyResolve
        reorderable_table_for stage_workflow.stage_tasks do
          column :task
          # noinspection RubyResolve
          list_column 'Parameters' do |stage_task|
            # stage_task.stage_workflow.parameter_values.each_with_object({}) do |(k, v), result|
            #   next unless k =~ /^#{stage_task.task.name}#(.*)$/
            #   result[$1] = v
            # end
            stage_task.stage_workflow.parameters_for(stage_task.task.name, recursive: true).reduce({}) {|r, (k,v)|
              n = k.gsub(/^.*#/, '')
              n = "<b>#{n}</b>" if v[:export]
              r[n] = (v[:data_type] == 'bool' ? v[:default] == 't' : (v[:default] || ''))
              r
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
          column :delegation, as: :tags do |param_ref|
            param_ref.delegation
          end
          column :export_name do |param_ref|
            param_ref.name if param_ref.export
          end
          # noinspection RubyResolve
          column :default
          column :description
          column '' do |param_ref|
            help_icon param_ref.help
            # noinspection RubyResolve
            action_icons path: admin_stage_workflow_parameter_ref_path(stage_workflow, param_ref), actions: %i[edit delete]
          end
        end
        div do
          "Available parameters to configure the stage's tasks. The number and type of parameters " +
              "will be different, depending on the tasks choosen:".html_safe
        end
        data = []
        resource.tasks.each do |task|
          task.parameter_defs.each do |param_def|
            h = param_def.to_hash
            h[:task] = task.name
            next if resource.parameter_refs.where("'#{h[:task]}##{h[:name]}' = ANY (delegation)").count > 0
            data << h
          end
        end
        table_for data do
          column :task
          column :name
          column :data_type
          column :default
          column :description
          column '' do |data|
            help_icon data[:help]
            new_button :stage_workflow, :parameter_ref,
                       values: {
                           teneo_data_model_parameter_ref: {
                               name: data[:name],
                               delegation_list: "#{data[:task]}##{data[:name]}",
                               with_param_refs_type: resource.class.name,
                               with_param_refs_id: resource.id
                           }
                       }
          end
        end
      end

      tab 'Referenced by', class: 'panel_contents' do
        table_for stage_workflow.ingest_workflows do
          column :organization do |obj|
            obj = obj.ingest_agreement.organization
            # noinspection RubyResolve
            link_to obj.name, admin_organization_path(obj)
          end
          column :ingest_agreement do |obj|
            obj = obj.ingest_agreement
            # noinspection RubyResolve
            link_to obj.name, admin_organization_ingest_agreement_path(obj.organization, obj)
          end
          column :ingest_workflow do |obj|
            # noinspection RubyResolve
            link_to obj.name, admin_ingest_agreement_ingest_workflow_path(obj.ingest_agreement, obj)
          end
        end
      end

    end
  end

end
