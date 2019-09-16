# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ParameterRef, as: 'ParameterRef' do

  menu false

  config.sort_order = 'created_at_asc'
  config.batch_actions = false

  actions :new, :create, :update, :edit, :destroy

  # belongs_to :ingest_workflow, :stage_workflow, :package, :storage, polymorphic: true

  controller do

    # belongs_to :ingest_workflow, :stage_workflow, :package, :storage, polymorphic: true

    # belongs_to :ingest_workflow, parent_class: Teneo::DataModel::IngestWorkflow, polymorphic: true
    # belongs_to :stage_workflow, parent_class: Teneo::DataModel::StageWorkflow, polymorphic: true
    # belongs_to :package, parent_class: Teneo::DataModel::Package, polymorphic: true
    # belongs_to :storage, parent_class: Teneo::DataModel::Storage, polymorphic: true

    def create
      create! do |format|
        format.html {redirect_to back_path}
      end
    end

    def update
      update! do |format|
        format.html {redirect_to back_path}
      end
    end

    def destroy
      destroy! do |format|
        format.html {redirect_to back_path}
      end
    end
  end

  permit_params :name, :delegation, :default, :value, :description, :help,
                :with_param_refs_id, :with_param_refs_type, :lock_version

  form do |f|
    f.inputs '' do
      f.input :name, required: true
      f.input :delegation, required: true, as: :tags
      f.input :default
      f.input :description
      f.input :help, as: :text, input_html: {rows: 3}
      f.hidden_field :lock_version
      f.hidden_field :with_param_refs_id
      f.hidden_field :with_param_refs_type
    end
    f.actions do
      f.action :submit
      f.cancel_link(back_path)
    end
  end

end
