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
            list_for parent_resource: stage_workflow, resource: stage_task
          end
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_stage_workflow_stage_task_path(model.stage_workflow, model)
          end
        end
        new_button :stage_workflow, :stage_task
      end

      tab 'Parameters', class: 'panel_contents' do
        # noinspection RubyResolve
        parameter_tab resource: stage_workflow,
                      message: 'Available parameters to configure the stage\'s tasks. ' +
                          'The number and type of parameters will be different, depending on the tasks choosen.'
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
