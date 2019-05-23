#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Producer, as: 'Producer' do
  menu parent: 'Code Tables', priority: 1

  actions :index, :new, :edit, :destroy

  controller do
    # noinspection RubySuperCallWithoutSuperclassInspection,RubyBlockToMethodReference,RubyResolve
    def create; super {collection_url};end

    # noinspection RubyBlockToMethodReference,RubySuperCallWithoutSuperclassInspection,RubyResolve
    def update
      params[:teneo_data_model_producer].delete(:password) if params[:teneo_data_model_producer][:password].blank?
      super {collection_url}
    end
  end

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :ext_id, :inst_code, :description, :agent, :password, :lock_version

  filter :name
  filter :description
  filter :ext_id
  filter :inst_code
  # filter :ingest_agreements

  index do
    column :name
    column :description
    column :inst_code
    column :agent
    column :ext_id
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
  #     attributes_table_for object do
  #       row :agent
  #       row :inst_code
  #       row :ext_id
  #     end
  #     # noinspection RubyResolve
  #     action_icons path: resource_path(object), actions: %i[edit delete]
  #   end
  # end

  form do |f|
    f.inputs 'Producer info' do
      f.input :name, required: true
      f.input :inst_code, label: 'Organization', required: true, as: :select, collection: Teneo::DataModel::Organization.pluck(:name, :inst_code)
      f.input :ext_id, required: true
      f.input :agent, required: true
      f.input :password, placeholder: '********', required: true
      f.input :description
      f.hidden_field :lock_version
    end
    actions
  end

end
