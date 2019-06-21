#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ConversionJob, as: 'ConversionJob' do

  belongs_to :representation, parent_class: Teneo::DataModel::Representation
  reorderable

  config.sort_order = 'position_asc'
  config.batch_actions = false

  permit_params :position, :name, :input_formats_list, :input_filename_regex,
                :representation_id, :lock_version

  filter :name

  index as: :reorderable_table do
    back_button
    column :name
    column :input_formats_list, as: :tags
    column :input_filename_regex
    column :converter
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object)
    end
  end

  show do
    back_button
    attributes_table do
      row :name
      row :input_formats_list, as: :tags
      row :input_filename_regex
    end
    tabs do

      tab 'Conversion tasks', class: 'panel_contents' do
        # noinspection RubyResolve
        reorderable_table_for conversion_job.conversion_tasks.order(position: 'asc') do
          column :name
          column :description
          column :converter do |task|
            task.converter
          end
          column :output_format
          # noinspection RubyResolve
          list_column 'Parameters' do |task|
            task.parameter_values.inject({}) { |hash, value| hash[value.name] = value.value; hash }
          end
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_conversion_job_conversion_task_path(model.conversion_job, model)
          end
        end
        new_button :representation, :conversion_job
      end

    end
  end

  form do |f|
    f.inputs 'Conversion job info' do
      f.input :name, required: true
      f.input :input_formats_list, as: :tags, collection: Teneo::DataModel::Format.all_tags
      f.input :input_filename_regex
      f.hidden_field :lock_version
    end
    actions
  end

end
