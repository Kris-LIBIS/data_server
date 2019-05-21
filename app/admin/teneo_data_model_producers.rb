#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Producer, as: 'Producer' do
  menu parent: 'Code Tables', priority: 1

  actions :index, :new, :edit, :destroy

  controller do
    # noinspection RubySuperCallWithoutSuperclassInspection,RubyResolve
    def create
      # noinspection RubySuperCallWithoutSuperclassInspection
      super do |_|
        redirect_to collection_url and return if resource.valid?
      end
    end

    # noinspection RubySuperCallWithoutSuperclassInspection,RubyResolve
    def update
      params[:teneo_data_model_producer].delete(:password) if params[:teneo_data_model_producer][:password].blank?
      super do |_|
        redirect_to collection_url and return if resource.valid?
      end
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
      action_icons object, %i'edit delete'
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
  #     action_icons object, %i'edit delete'
  #   end
  # end

  form do |f|
    f.inputs 'Producer info' do
      f.input :name, required: true
      f.input :inst_code, required: true
      f.input :ext_id, required: true
      f.input :agent, required: true
      f.input :password, placeholder: '******', required: true
      f.input :description
      f.hidden_field :lock_version
    end
    actions
  end

end
