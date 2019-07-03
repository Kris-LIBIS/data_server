#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ParameterValue, as: 'ParameterValue' do

  menu false

  config.sort_order = 'created_at_asc'
  config.batch_actions = false

  actions :new, :create, :update, :edit, :destroy

  controller do
    belongs_to :storage, parent_class: Teneo::DataModel::Storage, polymorphic: true
    belongs_to :stage_task, parent_class: Teneo::DataModel::StageTask, polymorphic: true
    belongs_to :ingest_task, parent_class: Teneo::DataModel::IngestTask, polymorphic: true
    belongs_to :package, parent_class: Teneo::DataModel::Package, polymorphic: true
    belongs_to :conversion_task, parent_class: Teneo::DataModel::ConversionTask, polymorphic: true

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

  permit_params :name, :value, :with_values_id, :with_values_type, :lock_version

  form do |f|
    f.inputs '' do
      f.input :name, required: true
      f.input :value, required: true
      f.hidden_field :lock_version
      f.hidden_field :with_values_id
      f.hidden_field :with_values_type
    end
    f.actions do
      f.action :submit
      f.cancel_link(:back)
    end
  end

end
