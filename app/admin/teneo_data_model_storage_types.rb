# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::StorageType, as: 'StorageType' do
  menu parent: 'Ingest tools', priority: 4

  actions :index, :new, :edit, :destroy

  controller do
    # noinspection RubySuperCallWithoutSuperclassInspection,RubyBlockToMethodReference,RubyResolve
    def create; super {collection_url};end

    # noinspection RubyBlockToMethodReference,RubySuperCallWithoutSuperclassInspection,RubyResolve
    def update; super {collection_url};end
  end

  config.sort_order = 'protocol_asc'
  config.batch_actions = false

  permit_params :protocol, :description, :lock_version

  filter :protocol
  filter :description

  index do
    column :protocol
    column :description
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[edit delete]
    end
  end

  # index as: :grid, default: true do |object|
  #   # noinspection RubyResolve
  #   panel link_to(object.name, edit_resource_path(object)) do
  #     para object.description
  #     # noinspection RubyResolve
  #     action_icons path: resource_path(object), actions: %i[edit delete]
  #   end
  # end

  show do
    attributes_table do
      row :protocol
      row :description
    end

    tabs do

      tab 'Parameters', class: 'panel_contents' do
        table_for storage_type.parameter_defs.order(:id) do
          column :name
          column :description
          column :data_type
          column :default
          column :constraint
          column '' do |param_def|
            # noinspection RubyResolve
            action_icons path: admin_storage_type_parameter_def_path(storage_type, param_def), actions: %i[edit delete]
            help_icon param_def.help
          end
        end
        new_button :storage_type, :parameter_def
      end

    end
  end

  form do |f|
    f.inputs 'StorageType info' do
      f.input :protocol, required: true
      f.input :description
      f.hidden_field :lock_version
    end
    actions
  end

end
