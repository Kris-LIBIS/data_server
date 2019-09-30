# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Storage, as: 'Storage' do
  menu false

  belongs_to :organization, parent_class: Teneo::DataModel::Organization

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :is_upload, :organization_id, :storage_type_id, :lock_Version

  filter :name

  index do
    back_button
    column :name
    column :is_upload
    column :protocol do |obj|
      obj.storage_type.protocol
    end
    # noinspection RubyResolve
    list_column :parameters do |obj|
      obj.parameter_values.transform_keys { |k| k.gsub(/^.*#/, '') }
    end
    actions defaults: false do |obj|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(obj), actions: %i[view edit delete]
    end
  end

  show do

    # noinspection RubyResolve
    back_button

    attributes_table do
      row :name
      row :is_upload
      row :protocol do |obj|
        # noinspection RubyResolve
        obj.storage_type.protocol
      end
    end

    # noinspection RubyResolve
    panel 'Parameters' do
      parameter_tab resource: resource,
                    message: "Available parameters to configure the storage. The number and type of parameters " +
                                "will be different, depending on the protocol choosen:"
    end
  end

  form do |f|
    f.inputs do
      f.input :name, required: true
      f.input :is_upload
      f.input :storage_type, required: true, collection: Teneo::DataModel::StorageType.all
      f.hidden_field :lock_version
    end
    f.actions
  end

end
