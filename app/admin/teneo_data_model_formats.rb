require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Format, as: 'Format' do
  menu label: 'Formats database', parent: 'Code Tables'

  config.sort_order = 'name_asc'
  config.batch_actions = false
  config.paginate = true

  permit_params :category, :name, :description, #:lock_version,
                :extensions_list,:mime_types_list, :puids_list

  # User can use scopes instead
  # filter :category, as: :select, collection: Teneo::DataModel::Format::CATEGORY_LIST
  filter :name
  filter :description

  scope :all, default: true
  Teneo::DataModel::Format::CATEGORY_LIST.each do |cat|
    scope cat, group: :category do |formats|
      formats.where(category: cat)
    end
  end

  # noinspection RubyResolve
  index do
    column :name
    column :category
    column :description
    column 'File extensions', :extensions_list
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[edit delete]
    end
  end

  # index as: :grid do |object|
  #   # noinspection RubyResolve
  #   panel link_to(object.name, edit_resource_path(object)) do
  #     para object.description
  #     # noinspection RubyResolve
  #     action_icons path: resource_path(object), actions: %i[edit delete]
  #   end
  # end

  show do
    # noinspection RubyResolve
    attributes_table do
      row :category
      row :name
      row :description
      row 'File extensions' do
        resource.extensions_list
      end
      row 'MIME types' do
        resource.mime_types_list
      end
      row 'PRONOM Unique Identifiers' do
        resource.puids_list
      end
    end
  end

  form do |f|
    f.inputs 'Format info' do
      f.input :name, required: true
      f.input :description
      f.input :category, required: true, as: :select, collection: Teneo::DataModel::Format::CATEGORY_LIST
      f.input :extensions_list, label: 'File extensions', required: true, as: :tags
      f.input :mime_types_list, label: 'MIME types', required: true, as: :tags
      f.input :puids_list, label: 'PRONOM Unique Identifiers', as: :tags
      # f.hidden_field :lock_version
    end
    actions
  end


end
