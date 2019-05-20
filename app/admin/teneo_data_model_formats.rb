require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Format, as: 'Format' do
  menu label: 'Formats database', parent: 'Code Tables'

  config.sort_order = 'name_asc'
  config.batch_actions = false
  config.paginate = true

  permit_params :category, :name, :description, #:lock_version,
                mime_types: [], puids: [], extensions: []

  filter :category, as: :select, collection: proc { Teneo::DataModel::Format.distinct.order(:category).pluck(:category) }
  filter :name
  filter :description

  scope :all, default: true
  Teneo::DataModel::Format.distinct.order(:category).pluck(:category).each do |cat|
    scope cat, group: :category do |formats|
      formats.where(category: cat)
    end
  end
  # noinspection RubyResolve
  index do
    column :name
    column :category
    column :description
    column :extensions
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons object
    end
  end

  show do
    # noinspection RubyResolve
    attributes_table do
      row :category
      row :name
      row :description
      row :extensions
      row :mime_types
      row :puids
    end
  end

  form do |f|
    f.inputs 'Format info' do
      f.input :category, as: :select, collection: Teneo::DataModel::Format.distinct.order(:category).pluck(:category)
      f.input :name
      f.input :description
      f.input :extensions, as: :tags
      f.input :mime_types, as: :tags
      f.input :puids, as: :tags
      # f.hidden_field :lock_version
    end
    actions
  end


end
