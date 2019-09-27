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
      table_for resource.parameter_refs.order(:id) do
        column :protocol do |param_ref|
          param_ref.delegation.first.gsub(/#.*/, '')
        end
        column :name
        column :default
        column '' do |param_ref|
          # noinspection RubyResolve
          action_icons path: admin_storage_parameter_ref_path(resource, param_ref), actions: %i[edit delete]
        end
      end
      div do
        "Available parameters to configure the storage. The number and type of parameters " +
            "will be different, depending on the protocol choosen:".html_safe
      end
      data = []
      resource.storage_type.parameter_defs.each do |param_def|
        h = param_def.to_hash
        next if resource.parameter_refs.find_by(delegation: "{#{resource.storage_type.name}##{h[:name]}}")
        data << h
      end
      puts data.to_s
      table_for data do
        column :name
        column :data_type
        column :default
        column :description
        column '' do |data|
          help_icon data[:help]
          new_button :storage, :parameter_ref,
                     values: {
                         teneo_data_model_parameter_ref: {
                             name: data[:name],
                             delegation_list: "#{resource.storage_type.name}##{data[:name]}",
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
    f.inputs do
      f.input :name, required: true
      f.input :is_upload
      f.input :storage_type, required: true, collection: Teneo::DataModel::StorageType.all
      f.hidden_field :lock_version
    end
    f.actions
  end

end
