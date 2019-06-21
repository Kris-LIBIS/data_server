#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Representation, as: 'Representation' do

  belongs_to :ingest_model, parent_class: Teneo::DataModel::IngestModel
  reorderable

  config.sort_order = 'position_asc'
  config.batch_actions = false

  permit_params :position, :label, :optional,
                :access_right_id, :representation_info_id, :from_id, :ingest_model_id,
                :lock_version

  filter :optional
  filter :access_right
  filter :representation_info

  index as: :reorderable_table do
    back_button
    column :label
    column :representation_info
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object)
    end
  end

  show do
    back_button

    attributes_table do
      row :label
      # noinspection RubyResolve
      bool_row :optional
      row :access_right
      row :representation_info
      row :from
    end

    tabs do

      tab 'Conversion jobs', class: 'panel_contents' do
        # noinspection RubyResolve
        reorderable_table_for representation.conversion_jobs.order(position: 'asc') do
          column :name
          column :description
          column :input_formats
          column :input_filename_regex
          # noinspection RubyResolve
          list_column :tasks do |job|
            job.conversion_tasks.map(&:name)
          end
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_representation_conversion_job_path(model.representation, model)
          end
        end
        new_button :representation, :conversion_job
      end

    end
  end

  form do |f|
    f.inputs 'Info' do
      f.input :label, required: true
      f.input :optional
      f.input :access_right_id, as: :select, collection: Teneo::DataModel::AccessRight.all
      f.input :representation_info_id, as: :select, collection: Teneo::DataModel::RepresentationInfo.all
      f.input :from, as: :select, collection: resource.ingest_model.representations.all
      f.hidden_field :lock_version
    end
    actions
  end

end
