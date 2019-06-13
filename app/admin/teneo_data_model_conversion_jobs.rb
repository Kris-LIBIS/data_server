#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ConversionJob, as: 'ConversionJob' do

  belongs_to :manifestation
  # navigation_menu :manifestation

  config.sort_order = 'position_asc'
  config.batch_actions = false

  permit_params :position, :name, :input_formats_list, :input_filename_regex,
                :manifestation_id, :lock_version

  filter :name

  index do
    back_button :manifestation, :ingest_model
    column :name
    column :position
    column :input_formats_list, as: :tags
    column :input_filename_regex
    column :config
    column :converter
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object)
    end
  end

  show do
    back_button :manifestation, :ingest_model
    attributes_table do
      row :name
      row :position
      row :input_formats_list, as: :tags
      row :input_filename_regex
    end
    tabs do

      tab 'Conversion tasks', class: 'panel_contents' do
        table_for conversion_job.conversion_tasks.order(position: 'asc') do
          column :name
          column :description
          column :converter do |task|
            task.converter
          end
          column :output_format
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_conversion_job_conversion_task_path(model.conversion_job, model)
          end
        end
        new_button :manifestation, :conversion_job
      end

    end
  end

  form do |f|
    f.inputs 'Conversion job info' do
      f.input :name, required: true
      f.input :position, required: true
      f.input :input_formats_list, as: :tags, collection: Teneo::DataModel::Format.all_tags
      f.input :input_filename_regex
      f.hidden_field :lock_version
    end
    actions
  end

end
