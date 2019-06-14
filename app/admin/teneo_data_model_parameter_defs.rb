#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ParameterDef, as: 'ParameterDef' do

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
      # redirect_to :back
    end

  end

  controller do
    belongs_to :converter, :task, :workflow, polymorphic: true
  end

  config.sort_order = 'id_asc'
  config.batch_actions = false

  permit_params :name, :description, :data_type, :help, :default, :constraint,
                :with_parameters_id, :with_parmeters_type, :lock_version

  # json_editor

  form do |f|
    f.inputs '' do
      f.input :name, required: true
      f.input :description
      f.input :data_type, required: true
      f.input :help, as: :text, input_html: {rows: 3}
      f.input :default
      f.input :constraint
      f.hidden_field :lock_version
      f.hidden_field :with_parameters_id
      f.hidden_field :with_parameters_type
    end
    f.actions do
      f.action :submit
      f.cancel_link(:back)
    end
  end

end
