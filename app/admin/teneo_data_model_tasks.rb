# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Task, as: 'Task' do
  menu parent: 'Ingest tools', priority: 2

  # actions :index, :new, :edit, :destroy

  controller do
    # noinspection RubySuperCallWithoutSuperclassInspection,RubyBlockToMethodReference,RubyResolve
    def create;
      super {collection_url};
    end

    # noinspection RubyBlockToMethodReference,RubySuperCallWithoutSuperclassInspection,RubyResolve
    def update;
      super {collection_url};
    end
  end

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :description, :class_name, :stage, :lock_version

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
      if obj.stage_workflows.count > 0
        # noinspection RubyResolve
        button_link href: resource_path(obj, anchor: 'referenced-by'), title: obj.stage_workflows.count
      end
    end
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[view delete]
    end
  end

  show do
    attributes_table do
      row :stage
      row :name
      row :class_name
      row :description
      row :help
    end

    tabs do

      # noinspection DuplicatedCode
      tab 'Parameters', class: 'panel_contents' do
        # noinspection RubyResolve
        parameter_def_tab resource: task
      end

      tab 'Referenced by', class: 'panel_contents' do
        table_for task.stage_workflows do
          column :stage_workflow do |obj|
            obj = obj
            # noinspection RubyResolve
            link_to obj.name, admin_stage_workflow_path(obj)
          end
        end
      end

    end
  end

  # noinspection DuplicatedCode
  form do |f|
    f.inputs do
      f.input :stage, required: true, collection: Teneo::DataModel::Task::STAGE_LIST
      f.input :name, required: true
      f.input :class_name
      f.input :description
      f.input :help, as: :text, input_html: {rows: 3}
      f.hidden_field :lock_version
    end
    actions
  end

end
