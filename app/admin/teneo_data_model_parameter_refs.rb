# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ParameterRef, as: 'ParameterRef' do

  menu false

  config.sort_order = 'created_at_asc'
  config.batch_actions = false

  actions :new, :create, :update, :edit, :destroy, :index

  # belongs_to :ingest_workflow, :stage_workflow, :package, :storage, polymorphic: true

  controller do

    # belongs_to :ingest_workflow, :stage_workflow, :package, :storage, polymorphic: true

    # belongs_to :ingest_workflow, parent_class: Teneo::DataModel::IngestWorkflow, polymorphic: true
    # belongs_to :stage_workflow, parent_class: Teneo::DataModel::StageWorkflow, polymorphic: true
    # belongs_to :package, parent_class: Teneo::DataModel::Package, polymorphic: true
    # belongs_to :storage, parent_class: Teneo::DataModel::Storage, polymorphic: true

    def create
      params['teneo_data_model_parameter_ref'].delete('virtual_delegation_list_attr')
      create! do |format|
        format.html { redirect_to back_path(info: {type: resource.with_param_refs_type.split('::').last.underscore,
                                             id: resource.with_param_refs.id}, anchor: 'parameters') }
      end
    end

    def update
      params['teneo_data_model_parameter_ref'].delete('virtual_delegation_list_attr')
      update! do |format|
        format.html { redirect_to back_path(info: {type: resource.with_param_refs_type.split('::').last.underscore,
                                             id: resource.with_param_refs.id}, anchor: 'parameters')}
      end
    end

    def destroy
      destroy! do |format|
        format.html { redirect_to back_path(info: {type: resource.with_param_refs_type.split('::').last.underscore,
                                             id: resource.with_param_refs.id}, anchor: 'parameters')}
      end
    end
  end

  permit_params :name, :delegation_list, :export, :constraint, :default, :description, :help,
                :with_param_refs_id, :with_param_refs_type, :lock_version, :virtual_delegation_list_attr

  filter :name
  filter :delegation
  filter :export
  filter :description
  filter :help
  filter :with_param_refs_type, label: :parent_type
  filter :storages
  # filter :with_param_refs, as: :select, collection: Teneo::DataModel::ParameterRef.all.map { |pr| pr.with_param_refs }

  index do
    back_button anchor: 'parameters'
    column :name
    column :parent do |obj|
      link_to "#{obj.with_param_refs_type} - #{obj.with_param_refs.name}",
              back_path({type: obj.with_param_refs_type.split('::').last.downcase, id: obj.with_param_refs.id})
    end
    column :parent_type do |obj|
      obj.with_param_refs_type
    end
    column :parent_name do |obj|
      obj.with_param_refs.name
    end
    column :delegation_list
    column :export
    column :default
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[view delete]
    end
  end

  form do |f|
    f.inputs '' do
      f.input :name, required: true
      f.input :delegation_list, required: true, as: :tags
      f.input :default
      f.input :export
      f.input :constraint
      f.input :description
      f.input :help, as: :text, input_html: {rows: 3}
      f.hidden_field :lock_version
      f.hidden_field :with_param_refs_id
      f.hidden_field :with_param_refs_type
    end
    f.actions do
      f.action :submit
      back_button anchor: 'parameters'
      # f.cancel_link(back_path)
    end
  end

end
