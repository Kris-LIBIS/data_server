#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Manifestation, as: 'Manifestation' do

  belongs_to :ingest_model, parent_class: Teneo::DataModel::IngestModel
  # navigation_menu :ingest_model

  config.sort_order = 'position_asc'
  config.batch_actions = false

  permit_params :position, :label, :optional,
                :access_right_id, :representation_info_id, :from_id, :ingest_model_id,
                :lock_version

  filter :optional
  filter :access_right
  filter :representation_info

  index do
    back_button :ingest_model, :ingest_agreement
    column :position
    column :label
    column :representation_info
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object)
    end
  end

  show do
    back_button :ingest_model, :ingest_agreement

    tabs do

      tab 'Info' do
        # noinspection RubyResolve
        attributes_table do
          row :position
          row :label
          row :optional
          row :access_right
          row :representation_info
          row :from
        end
      end

      tab 'Conversion jobs', class: 'panel_contents' do
        table_for manifestation.conversion_jobs.order(position: 'asc') do
          column :format_filter
          column :filename_filter
          column :converter do |cj|
            cj.converter
          end
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_manifestation_conversion_job_path(model.manifestation, model)
          end
        end
        new_button :manifestation, :conversion_job
      end

    end
  end

  form do |f|
    f.inputs 'Info' do
      f.input :position
      f.input :label, required: true
      f.input :optional
      f.input :access_right_id, as: :select, collection: Teneo::DataModel::AccessRight.all
      f.input :representation_info_id, as: :select, collection: Teneo::DataModel::RepresentationInfo.all
      f.input :from, as: :select, collection: resource.ingest_model.manifestations.all
      f.hidden_field :lock_version
    end
    actions
  end


end
