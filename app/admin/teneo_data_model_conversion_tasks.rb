# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ConversionTask, as: 'ConversionTask' do

  belongs_to :conversion_workflow, parent_class: Teneo::DataModel::ConversionWorkflow
  reorderable

  config.sort_order = 'position_asc'
  config.batch_actions = false

  permit_params :position, :name, :description, :output_format,
                :conversion_workflow_id, :converter_id,
                :lock_version

  filter :name

  index as: :reorderable_table do
    back_button
    column :name
    column :description
    column :converter

    column :output_format
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object)
    end
  end

  show do

    back_button

    attributes_table do
      row :name
      row :description
      row :converter
      row :output_format
    end

    # noinspection RubyResolve
    panel 'Parameters' do
      table_for resource.parameter_refs.order(:id) do
        column :converter do |param_ref|
          param_ref.delegation.first.gsub(/#.*/, '')
        end
        column :name
        column :default
        column '' do |param_ref|
          # noinspection RubyResolve
          action_icons path: admin_conversion_task_parameter_ref_path(resource, param_ref), actions: %i[edit delete]
        end
      end
      div do
        "Available parameters to configure the converter. The number and type of parameters " +
            "will be different, depending on the converter choosen:".html_safe
      end
      data = []
      resource.converter.parameter_defs.each do |param_def|
        h = param_def.to_hash
        next if resource.parameter_refs.find_by(delegation: "{#{resource.converter.name}##{h[:name]}}")
        data << h
      end
      table_for data do
        column :name
        column :data_type
        column :default
        column :description
        column '' do |data|
          help_icon data[:help]
          new_button :conversion_task, :parameter_ref,
                     values: {
                         teneo_data_model_parameter_ref: {
                             name: data[:name],
                             delegation_list: "#{resource.converter.name}##{data[:name]}",
                             with_param_refs_type: resource.class.name,
                             with_param_refs_id: resource.id
                         }
                     }
        end
      end
      # new_button :storage, :parameter_ref
    end

  end

  form do |f|
    f.inputs 'Conversion task info' do
      f.input :name, required: true
      f.input :description
      f.input :converter, as: :select, collection: Teneo::DataModel::Converter.all
      f.input :output_format, as: :select, collection: Teneo::DataModel::Format.pluck(:name)
      f.hidden_field :lock_version
    end
    actions
  end

end
