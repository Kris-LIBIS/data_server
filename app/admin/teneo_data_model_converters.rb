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

  # page_action :add_parameter_def do |converter_id|
  #   # noinspection RubyResolve
  #   render add_parameter_def_admin_converter_path(converter_id), locals: {
  #       form: ::Admin::Converters::AddParameterForm.new(converter_id)
  #   }
  # end

  member_action :add_parameter_def, method: :post do
    # noinspection RubyResolve
    form = ::Admin::Converters::AddPararmeterForm.new(params.fetch(:id))
    if form.submit(params)
      # noinspection RubyResolve
      redirect_to resource_path(resource, anchor: 'parameters'), notice: "Parameter added"
    else
      flash[:notice] = "Could not create parameter"
      # noinspection RubyResolve
      render add_parameter_def_admin_converter_path(resource), locals: {form: form}
    end
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
      action_icons path: resource_path(object), actions: %i[view delete]
    end
  end

  show do
    attributes_table do
      row :name
      row :description
      row :class_name
      row :script_name
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
      f.hidden_field :lock_version
    end
    actions
  end

end
