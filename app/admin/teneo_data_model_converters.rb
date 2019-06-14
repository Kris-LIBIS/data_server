#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Converter, as: 'Converter' do
  menu parent: 'Ingest tools', priority: 10

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
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[view delete]
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

      tab 'Parameters', class: 'panel_contents' do
        table_for converter.parameter_defs.order(:id) do
          column :name
          column :description
          column :data_type
          column :default
          column :constraint
          column '' do |param_def|
            # noinspection RubyResolve
            action_icons path: admin_converter_parameter_def_path(converter, param_def), actions: %i[edit delete]
            help_icon param_def.help
          end
        end
        new_button :converter, :parameter_def
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
