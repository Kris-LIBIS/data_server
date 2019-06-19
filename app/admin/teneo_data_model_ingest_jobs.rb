#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::IngestJob, as: 'IngestJob' do

  belongs_to :ingest_agreement, parent_class: Teneo::DataModel::IngestAgreement

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :description, :ingest_agreement_id, :lock_version

  filter :name
  filter :description

  index do
    back_button
    column :name
    column :description
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[view delete]
    end
  end

  show do
    back_button
    attributes_table do
      row :name
      row :description
    end
    tabs do
      tab 'Ingest Tasks' do
        table_for ingest_job.ingest_tasks do
          column :stage
          column :workflow
          column 'Parameters' do |task|
            task.parameter_values.map {|value| "#{value.name}='#{value.value}'"}.join(" ")
          end
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_ingest_job_ingest_task_path(model.ingest_job, model)
          end
        end
        new_button :ingest_task, :ingest_job
      end
    end
  end

  form do |f|
    f.inputs 'Info' do
      f.input :name, required: true
      f.input :description
      f.hidden_field :lock_version
    end
    actions
  end

end
