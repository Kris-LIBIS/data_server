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
      parameter_tab resource: resource, message: "Available parameters to configure the converter. " +
          "The number and type of parameters will be different, depending on the converter choosen:"
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
