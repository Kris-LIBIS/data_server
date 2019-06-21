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
          # noinspection RubyResolve
          list_column :parameter_values do |task|
            task.parameter_values.inject({}) {|hash, value| hash[value.name] = value.value; hash}
          end
          column '' do |model|
            # noinspection RubyResolve
            action_icons path: admin_ingest_job_ingest_task_path(model.ingest_job, model)
          end
        end
        new_button :ingest_job, :ingest_task
      end
      tab 'Parameters', class: 'panel_contents' do
        table_for ingest_job.parameter_refs.order(:id) do
          column :name
          column :description
          column :delegation, as: :tags
          column :default
          column '' do |param_ref|
            # noinspection RubyResolve
            action_icons path: admin_ingest_job_parameter_ref_path(ingest_job, param_ref), actions: %i[edit delete]
            help_icon param_ref.help
          end
        end
        new_button :ingest_job, :parameter_ref
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
