#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ParameterDef, as: 'ParameterDef' do

  # belongs_to :with_parameters, polymorphic: true
  actions :index, :new, :edit, :destroy

  controller do
    # noinspection RubySuperCallWithoutSuperclassInspection,RubyBlockToMethodReference,RubyResolve
    def create; super {collection_url};end

    # noinspection RubyBlockToMethodReference,RubySuperCallWithoutSuperclassInspection,RubyResolve
    def update; super {collection_url};end
  end

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :description, :data_type, :help, :default, :constraint, :lock_version

  filter :name
  filter :description
  # filter :ingest_models
  # filter :manifestations

  index do
    column :name
    column :description
    column :data_type
    column :help
    column :default
    column :constraint
    column :with_parameters
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
    f.inputs '' do
      f.input :name, required: true
      f.input :description
      f.input :data_type, required: true
      t.input 'help' do |pdef|
        f.text_area :help
      end
      f.input :default
      f.input :constraint
      f.hidden_field :lock_version
    end
    actions
  end

end
