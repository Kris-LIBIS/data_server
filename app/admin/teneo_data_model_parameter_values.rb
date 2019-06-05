#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ParameterValue, as: 'ParameterValue' do
  menu parent: 'Code Tables', priority: 1

  actions :index, :new, :edit, :destroy

  controller do
    # noinspection RubySuperCallWithoutSuperclassInspection,RubyBlockToMethodReference,RubyResolve
    def create; super {collection_url};end

    # noinspection RubyBlockToMethodReference,RubySuperCallWithoutSuperclassInspection,RubyResolve
    def update; super {collection_url};end
  end

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :ext_id, :description, :lock_version

  filter :name
  filter :description
  filter :ext_id
  # filter :ingest_models
  # filter :manifestations

  index do
    column :name
    column :description
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
  #     action_icons path: resource_path(object), actions: %i[edit delete]
  #   end
  # end

  form do |f|
    f.inputs 'AccessRight info' do
      f.input :name, required: true
      f.input :description
      f.input :ext_id, required: true
      f.hidden_field :lock_version
    end
    actions
  end

end
