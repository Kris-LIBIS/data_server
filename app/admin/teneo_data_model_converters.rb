# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Converter, as: 'Converter' do
  menu parent: 'Ingest tools', priority: 1

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

  permit_params :name, :description, :class_name, :script_name,
                :input_formats_list, :output_formats_list, :lock_version

  filter :name
  filter :description

  index do
    column :name
    column :description
    column :referenced, class: 'button' do |obj|
      if obj.conversion_tasks.count > 0
        # noinspection RubyResolve
        button_link href: resource_path(obj, anchor: 'referenced-by'), title: obj.conversion_tasks.count
      end
    end
    actions defaults: false do |obj|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(obj), actions: %i[view delete]
    end
  end

  show do
    attributes_table do
      row :name
      row :description
      row :class_name
      row :script_name
      row :input_formats_list, as: :tags
      row :output_formats_list, as: :tags
    end

    tabs do

      # noinspection DuplicatedCode
      tab 'Parameters', class: 'panel_contents' do
        # noinspection RubyResolve
        parameter_def_tab resource: converter
      end

      tab 'Referenced by', class: 'panel_contents' do
        table_for converter.conversion_tasks do
          column :organization do |obj|
            obj = obj.conversion_workflow.representation.ingest_model.ingest_agreement.organization
            # noinspection RubyResolve
            link_to obj.name, admin_organization_path(obj)
          end
          column :ingest_agreement do |obj|
            obj = obj.conversion_workflow.representation.ingest_model.ingest_agreement
            # noinspection RubyResolve
            link_to obj.name, admin_organization_ingest_agreement_path(obj.organization, obj)
          end
          column :ingest_model do |obj|
            obj = obj.conversion_workflow.representation.ingest_model
            # noinspection RubyResolve
            link_to obj.name, admin_ingest_agreement_ingest_model_path(obj.ingest_agreement, obj)
          end
          column :representation do |obj|
            obj = obj.conversion_workflow.representation
            # noinspection RubyResolve
            link_to obj.name, admin_ingest_model_representation_path(obj.ingest_model, obj)
          end
          column :workflow do |obj|
            obj = obj.conversion_workflow
            # noinspection RubyResolve
            link_to obj.name, admin_representation_conversion_workflow_path(obj.representation, obj)
          end
          column :task do |obj|
            # noinspection RubyResolve
            link_to obj.name, admin_conversion_workflow_conversion_task_path(obj.conversion_workflow, obj)
          end
        end
      end

    end
  end

  form do |f|
    f.inputs do
      f.input :name, required: true
      f.input :description
      f.input :class_name
      f.input :script_name
      f.input :input_formats_list, as: :tags, collection: Teneo::DataModel::Format.pluck(:name)
      f.input :output_formats_list, as: :tags, collection: Teneo::DataModel::Format.pluck(:name)
      f.hidden_field :lock_version
    end
    actions
  end

end
