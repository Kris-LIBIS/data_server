#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::MaterialFlow, as: 'MaterialFlow' do
  menu parent: 'Code Tables', priority: 2

  actions :index, :new, :edit, :destroy

  controller do
    # noinspection RubySuperCallWithoutSuperclassInspection,RubyBlockToMethodReference,RubyResolve
    def create; super {collection_url};end

    # noinspection RubyBlockToMethodReference,RubySuperCallWithoutSuperclassInspection,RubyResolve
    def update; super {collection_url};end
  end

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :ext_id, :inst_code, :description, :lock_version

  filter :name
  filter :description
  filter :ext_id
  filter :inst_code
  # filter :ingest_agreements

  index do
    column :name
    column :description
    column :inst_code
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
  #       row :inst_code
  #       row :ext_id
  #     end
  #     # noinspection RubyResolve
  #     action_icons path: resource_path(object), actions: %i[edit delete]
  #   end
  # end

  form do |f|
    f.inputs 'Material Flow info' do
      f.input :name, required: true
      f.input :inst_code, required: true
      f.input :ext_id, required: true
      f.input :description
      f.hidden_field :lock_version
    end
    actions
  end

end
