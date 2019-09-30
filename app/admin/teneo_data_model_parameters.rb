# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Parameter, as: 'Parameter' do

  menu false

  config.sort_order = 'created_at_asc'
  config.batch_actions = false

  actions :new, :show, :create, :update, :edit, :destroy, :index

  permit_params :name, :export, :data_type, :constraint, :default, :description, :help,
                :target_list, :with_parameters_id, :with_parameters_type, :lock_version

  controller do

    # belongs_to :converter, parent_class: Teneo::DataModel::Converter, polymorphic: true
    # belongs_to :task, parent_class: Teneo::DataModel::Task, polymorphic: true
    # belongs_to :storage_type, parent_class: Teneo::DataModel::StorageType, polymorphic: true

    def return_path(resource)
      back_path(info: {type: resource.with_parameters_type.split('::').last.underscore,
                       id: resource.with_parameters.id}, anchor: 'parameters')
    end

    def create
      targets = params['teneo_data_model_parameter'].delete('target_list')
      create! do |format|
        if resource.valid?
          resource.target_list = targets
          format.html { redirect_to return_path(resource) }
        end
      end
    end

    def update
      targets = params['teneo_data_model_parameter'].delete('target_list')
      update! do |format|
        if resource.valid?
          resource.target_list = targets
          format.html { redirect_to return_path(resource) }
        end
      end
    end

    def destroy
      resource.targets.clear
      destroy! do |format|
        format.html { redirect_to return_path(resource) }
      end
    end
  end

  filter :name
  filter :export
  filter :description
  filter :help
  filter :with_parameters_type, label: :parent_type

  index do
    back_button anchor: 'parameters'
    column :parent do |obj|
      link_to "#{obj.with_parameters_type} - #{obj.with_parameters.name}",
              back_path(info: {type: obj.with_parameters_type.split('::').last.downcase, id: obj.with_parameters.id})
    end
    # column :parent_type do |obj|
    #   obj.with_parameters_type
    # end
    # column :parent_name do |obj|
    #   obj.with_parameters.name
    # end
    column :name
    column :data_type
    column :target_list, as: :tags
    column :export
    column :default
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[view delete]
    end
  end

  form do |f|
    f.inputs '' do
      f.semantic_errors
      f.input :name, required: true
      f.input :export, as: :boolean
      f.input :data_type
      f.input :constraint
      f.input :default
      f.input :target_list, as: :select, multiple: true, collection: f.object.target_candidates.map(&:reference_name)
      f.input :description
      f.input :help, as: :text, input_html: {rows: 3}
      f.hidden_field :lock_version
      f.hidden_field :with_parameters_id
      f.hidden_field :with_parameters_type
    end

    f.actions do
      f.action :submit
      back_button anchor: 'parameters'
    end

    # noinspection RubyResolve
    panel 'Referenced by' do
      table_for f.object.sources do
        column :reference_name
      end
    end unless f.object.sources.empty?

  end
end

