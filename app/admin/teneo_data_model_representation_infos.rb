#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::RepresentationInfo, as: 'RepresentationInfo' do
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
      super do |_|
        redirect_to collection_url and return if resource.valid?
      end
    end
  end

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :preservation_type, :usage_type, :representation_code, :lock_version

  filter :name
  filter :preservation_type, as: :select, collection: Teneo::DataModel::RepresentationInfo::PRESERVATION_TYPES
  filter :usage_type, as: :select, collection: Teneo::DataModel::RepresentationInfo::USAGE_TYPES
  filter :representation_code

  index do
    column :name
    column :preservation_type
    column :usage_type
    column :representation_code
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[edit delete]
    end
  end

  # index as: :grid, default: true do |object|
  #   # noinspection RubyResolve
  #   panel link_to(object.name, edit_resource_path(object)) do
  #     # noinspection RubyResolve
  #     attributes_table_for object do
  #       row :preservation_type
  #       row :usage_type
  #       row :representation_code
  #     end
  #     action_icons path: resource_path(object), actions: %i[edit delete]
  #   end
  # end

  form do |f|
    f.inputs 'RepresentationInfo info' do
      f.input :name, required: true
      f.input :preservation_type, required: true, as: :select, collection: Teneo::DataModel::RepresentationInfo::PRESERVATION_TYPES
      f.input :usage_type, required: true, as: :select, collection: Teneo::DataModel::RepresentationInfo::USAGE_TYPES
      f.input :representation_code
      f.hidden_field :lock_version
    end
    actions
  end

end
