# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::IngestWorkflow, as: 'IngestWorkflow' do

  # noinspection RailsParamDefResolve
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
    actions defaults: false do |obj|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(obj), actions: %i[view delete]
    end
  end

  show do
    back_button

    attributes_table do
      row :name
      row :description
    end

    tabs do

      tab 'Ingest Stages', class: 'panel_contents' do
        table_for ingest_workflow.ingest_stages do
          column :stage
          # noinspection RubyResolve
          toggle_bool_column :autorun
          column :stage_workflow
          # noinspection RubyResolve
          list_column 'Parameters' do |stage|
            stage.ingest_workflow.parameters_for(stage.stage_workflow.name, recursive: true).reduce({}) {|r, (k,v)|
              n = k.gsub(/^.*#/, '')
              n = "<b>#{n}</b>" if v[:export]
              r[n] = v[:data_type] == 'bool' ? v[:default] == 't' : v[:default].to_s
              r
            }
          end
          column '' do |stage|
            # noinspection RubyResolve
            action_icons path: admin_ingest_workflow_ingest_stage_path(stage.ingest_workflow, stage)
          end
        end
        new_button :ingest_workflow, :ingest_stage
      end

      tab 'Parameters', class: 'panel_contents' do
        table_for ingest_workflow.parameter_refs.order(:id) do
          column :delegation, as: :tags do |param_ref|
            param_ref.delegation
          end
          column :export_name do |param_ref|
            param_ref.name if param_ref.export
          end
          # noinspection RubyResolve
          column :default
          column :description
          column '' do |param_ref|
            help_icon param_ref.help
            # noinspection RubyResolve
            action_icons path: admin_ingest_workflow_parameter_ref_path(ingest_workflow, param_ref), actions: %i[edit delete]
          end
        end
        div do
          "The parameters configure the stage workflows. The following parameters can be referenced:".html_safe
        end
        data = []
        resource.child_parameters.each do |name, param|
            h = param
            h[:stage_workflow] = Teneo::DataModel::ParameterRef.delegation_host(name)
            next if resource.parameter_refs.where("'#{name}' = ANY (delegation)").count > 0
            data << h if h[:export]
        end
        puts data.to_s
        table_for data do
          column :stage_workflow
          column :name
          # do |data|
          #   Teneo::DataModel::ParameterRef.delegation_param(data[:name])
          # end
          column :data_type
          column :default do |data|
            data[:data_type] == 'bool' ? data[:default] == 't' : data[:default].to_s
          end
          column :description
          column '' do |data|
            help_icon data[:help]
            new_button :ingest_workflow, :parameter_ref,
                       values: {
                           teneo_data_model_parameter_ref: {
                               name: data[:name],
                               delegation_list: "#{data[:stage_workflow]}##{data[:name]}",
                               with_param_refs_type: resource.class.name,
                               with_param_refs_id: resource.id
                           }
                       }
          end
        end
      end

      tab 'Packages', class: 'panel_contents' do
        table_for ingest_workflow.packages.order(:created_at) do
          column :name do |package|
            auto_link package
          end
          column '' do |package|
            # noinspection RubyResolve
            action_icons path: admin_ingest_workflow_package_path(package.ingest_workdflow, package), actions: [:delete]
          end
        end
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
