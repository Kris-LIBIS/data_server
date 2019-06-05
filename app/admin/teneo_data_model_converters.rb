#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Converter, as: 'Converter' do
  menu parent: 'Ingest tools', priority: 10

  actions :index, :new, :edit, :destroy

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

  member_action :add_parameter_def, method: :post do
    parameter_def = params[:parameter_def] || {}
    parameter_def['name'] = resource.parameter_name || 'New parameter'
    parameter_def['data_type'] = resource,parameter_type || 'string'
    parameter_def['with_parameters'] = resource
    Teneo::DataModel::ParameterDef.create(parameter_def)
    # noinspection RubyResolve
    redirect_to edit_resource_path(resource, anchor: 'parameters'), notice: "Parameter added"
  end

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :description, :class_name, :script_name, :lock_version

  filter :name
  filter :description

  index do
    column :name
    column :description
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[edit delete]
    end
  end

  form do |f|
    tabs do
      tab 'Details' do
        f.inputs do
          f.input :name, required: true
          f.input :description
          f.input :class_name
          f.input :script_name
          f.hidden_field :lock_version
        end
        actions
      end
      tab 'Parameters' do
        table_for converter.parameter_defs do
          column :name
          column :description
          column :datatype
          column :default
          column :constraint
          column '' do |param_def|
            # noinspection RubyResolve
            action_icons path: admin_parameter_defs_path(param_def)
            p fa_icon(:help), title: param_def.help
          end
        end
        f.input :parameter_name
        f.input :parameter_type
        # div do
        #   label 'Name'
        #   text_field :parameter_name
        # end
        # div do
        #   label 'Data type'
        #   text_field :parameter_type
        # end
        # noinspection RubyResolve
        button_link href: add_parameter_def_admin_converter_path(converter),
                    title: 'New parameter', icon: 'plus-circle', classes: 'right-align'
      end
    end
  end

end
