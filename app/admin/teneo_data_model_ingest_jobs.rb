#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::IngestJob, as: 'IngestJob' do

  belongs_to :ingest_agreement, parent_class: Teneo::DataModel::IngestAgreement

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :stage, :config, :ingest_agreement_id, :workflow_id, :lock_version

  filter :stage
  filter :workflow

  index do
    back_button :ingest_agreement, :organization
    column :stage
    column :config
    column :workflow
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object)
    end
  end

  show do
    back_button :ingest_agreement, :organization
    attributes_table do
      row :stage
      row :config
      row :workflow
    end
  end

  form do |f|
    f.inputs 'Info' do
      f.input :stage, required: true, as: :select, collection: Teneo::DataModel::IngestJob::STAGE_LIST
      f.input :config, as: :jsonb
      f.input :workflow_id, as: :select, collection: Teneo::DataModel::Workflow.pluck(:name, :id)
      f.hidden_field :lock_version
    end
    actions
  end

end
