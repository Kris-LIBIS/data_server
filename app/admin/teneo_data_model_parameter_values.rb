#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ParameterValue, as: 'ParameterValue' do

  menu false

  actions :new, :create, :update, :edit, :destroy

  controller do
    def create!
      redirect_to :back
    end

    def update!
      redirect_to :back
    end

    def destroy!
      redirect_to :back
    end

  end

  controller do
    belongs_to :storage, :workflow_task, :conversion_job, :ingest_job, :package,  polymorphic: true
  end

end
