#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ParameterDef, as: 'ParameterDef' do

  menu false

  config.sort_order = 'created_at_asc'
  config.batch_actions = false

  actions :new, :create, :update, :edit, :destroy

  controller do
    belongs_to :converter, parent_class: Teneo::DataModel::Converter, polymorphic: true
    belongs_to :task, parent_class: Teneo::DataModel::Task, polymorphic: true
    belongs_to :workflow, parent_class: Teneo::DataModel::Workflow, polymorphic: true

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

  permit_params :name, :description, :data_type, :help, :default, :constraint,
                :with_parameters_id, :with_parmeters_type, :lock_version

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
      f.cancel_link(back_path)
    end
  end

end
