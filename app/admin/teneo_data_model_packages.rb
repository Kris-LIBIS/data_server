# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Package, as: 'Package' do

  belongs_to :ingest_workflow, parent_class: Teneo::DataModel::IngestWorkflow
  reorderable

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :base_dir, :stage, :status,
                :ingest_agreement_id, :lock_version

  filter :name

  index do
    back_button
    column :name
    column :base_dir
    column :stage
    column :status
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object)
    end
  end

  show do
    back_button

    attributes_table do
      row :name
      row :base_dir
      row :stage
      row :status
    end

    tabs do

      tab 'Parameters', class: 'panel_contents' do
        # noinspection RubyResolve
        parameter_tab resource: package,
                      message: "The parameters configure the package. The following parameters can be used:"
      end

      tab 'Runs', class: 'panel_contents' do
        # noinspection RubyResolve
        table_for package.runs do
          column :name do |run|
            auto_link run
          end
          column :start_date
          column :log_filename
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_package_run_path(model.package, model), actions: [:delete]
          end
        end
        # new_button :ingest_model, :representation
      end

=begin
      tab 'Items', class: 'panel_contents' do
        # noinspection RubyResolve
        reorderable_table_for package.items do
          column :type
          column :name do |item|
            auto_link item
          end
          column :parent do |item|
            auto_link item.parent, item.parent.name if item.parent.is_a?(Teneo::DataModel::Item)
          end
          column :label
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_package_item_path(model.package, model), actions: [:delete]
          end
        end
        # new_button :ingest_model, :representation
      end
=end

    end

  end

  form do |f|
    f.inputs 'Info' do
      input :name
      input :base_dir
      f.hidden_field :lock_version
    end
    actions
  end


end
