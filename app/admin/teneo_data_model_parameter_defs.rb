#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::ParameterDef, as: 'ParameterDef' do

  menu false
  # belongs_to :with_parameters, polymorphic: true
  actions :new, :edit, :destroy

  # controller do
  #   def create!
  #     redirect_to :back
  #   end
  #
  #   def update!
  #     redirect_to :back
  #   end
  # end

  controller do
  belongs_to :converter, :tasks, :workflow,  polymorphic: true
end

config.sort_order = 'name_asc'
config.batch_actions = false

  permit_params :name, :description, :data_type, :help, :default, :constraint, :lock_version

  form do |f|
    f.inputs '' do
      f.input :name, required: true
      f.input :description
      f.input :data_type, required: true
      f.input :help, as: :text, input_html: {rows: 4}
      f.input :default, input_html: {rows: 5}
      f.input :constraint, input_html: {rows: 5}
      f.hidden_field :lock_version
    end
    actions do
      action :submit
      link_to 'Cancel', url_for(:back)
    end
  end

end
