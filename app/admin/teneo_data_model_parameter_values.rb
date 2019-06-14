#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ParameterValue, as: 'ParameterValue' do

  menu false

  actions :new, :create, :update, :edit, :destroy

  controller do
    belongs_to :storage, :workflow_task, :conversion_task, :ingest_job, :package,  polymorphic: true
    def create
      super do |format|
        redirect_to request.fullpath if resource.valid?
      end
    end

    def update
      super do |format|
        redirect_to :back if resource.valid?
      end
    end

    def destroy
      super do |format|
        redirect_to :back
      end
    end

  end

  permit_params :name, :value, :with_values_id, :with_values_type, :lock_version

  index do
    column :name
    column :value
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[edit delete]
    end
  end

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
