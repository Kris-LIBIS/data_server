#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ConversionJob, as: 'ConversionJob' do

  belongs_to :manifestation
  # navigation_menu :manifestation

  config.sort_order = 'position_asc'
  config.batch_actions = false

  permit_params :position, :name, :format_filter, :filename_filter, :config,
                :manifestation_id, :converter_id,
                :lock_version

  filter :name

  index do
    back_button :manifestation, :ingest_model
    column :name
    column :position
    column :format_filter
    column :filename_filter
    column :config
    column :converter
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object)
    end
  end

  show do
    back_button :manifestation, :ingest_model
    attributes_table do
      row :name
      row :position
      row :format_filter
      row :filename_filter
      row :config
      row :converter
    end
  end

  form do |f|
    f.inputs 'Conversion job info' do
      f.input :name, required: true
      f.input :position, required: true
      f.input :format_filter
      f.input :filename_filter
      f.input :config, as: :jsonb
      f.input :converter, as: :select, collection: Teneo::DataModel::Converter.all
      f.hidden_field :lock_version
    end
    actions
  end

end
