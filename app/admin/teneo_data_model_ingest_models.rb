#frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::IngestModel, as: 'IngestModel' do

  belongs_to :ingest_agreement, parent_class: Teneo::DataModel::IngestAgreement
  navigation_menu :ingest_agreement

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :description, :entity_type, :user_a, :user_b, :user_c, :identifier, :status,
                :access_right_id, :retention_policy_id, :ingest_agreement_id, :template_id, :lock_version

  filter :name
  filter :entity_type
  filter :user_a
  filter :user_b
  filter :user_c
  filter :identifier

  index do
    column :name
    column :description
    column :entity_type
    column :template
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object)
    end
  end

  show do
    tabs do

      tab 'Info' do
        # noinspection RubyResolve
        attributes_table do
          row :name
          row :description
          row :entity_type
          row :template
          row :user_a
          row :user_b
          row :user_c
          row :identifier
          row :status
          row :access_right
          row :retention_policy
        end
      end

      tab 'Manifestations', class: 'panel_contents' do
          table_for ingest_model.manifestations do
            column :label
            column :optional
            column '' do |model|
              # noinspection RubyResolve
              action_icons path: admin_ingest_model_manifestation_path(model.ingest_model, model)
            end
          end
          button class: 'right-align' do
            # noinspection RubyResolve
            link_to fa_icon('plus-circle', title: 'New'), new_admin_ingest_model_manifestation_path(resource)
          end
        end

    end
  end

  form do |f|
    f.inputs 'Info' do
      f.input :name, required: true
      f.input :description
      f.input :entity_type
      f.input :template_id, as: :select, collection: Teneo::DataModel::IngestModel.all
      f.input :user_a
      f.input :user_b
      f.input :user_c
      f.input :identifier
      f.input :status
      f.input :access_right_id, required: true, as: :select, collection: Teneo::DataModel::AccessRight.all
      f.input :retention_policy, required: true, as: :select, collection: Teneo::DataModel::RetentionPolicy.all
      f.hidden_field :lock_version
    end
    actions
  end

end
