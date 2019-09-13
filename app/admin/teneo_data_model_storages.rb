# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Storage, as: 'Storage' do
  menu false

  belongs_to :organization, parent_class: Teneo::DataModel::Organization

  config.sort_order = 'name_asc'
  config.batch_actions = false

  permit_params :name, :is_upload, :organization_id, :lock_Version

  filter :name

  index do
    back_button
    column :name
    column :is_upload
    column :protocol do |obj|
      obj.storage_type.protocol
    end
    column :parameters do |obj|
      obj.parameters.each_with_object(Hash.new { |h, k| h[k] = {} }) {|(n, p), r| r[n] = p[:value] }
    end
    actions defaults: false do |obj|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(obj), actions: %i[edit delete]
    end
  end

  show do

    # noinspection RubyResolve
    back_button

    attributes_table do
      row :name
      row :protocol do |obj|
        # noinspection RubyResolve
        obj.storage_type.protocol
      end
    end

    columns do
      column do
        # noinspection RubyResolve
        panel 'Parameters' do
          table_for resource.parameter_values.order(:id) do
            column :name
            column :value
            column '' do |param_value|
              # noinspection RubyResolve
              action_icons path: admin_storage_parameter_value_path(resource, param_value), actions: %i[edit delete]
            end
          end
          new_button :storage, :parameter_value
        end
      end
      column do
        # noinspection RubyResolve
        panel :help do
          div do
            "The parameters configure the storage for a given protocol. The nnumber and type of parameters " +
                "will be different, depending on the protocol choosen:".html_safe
          end

          data = [
              {protocol: 'NFS', options: [
                  {tag: 'location', info: 'the path to the directory'},
              ]},
              {protocol: 'FTP', options: [
                  {tag: 'host', info: 'the hostname or ip-address of the FTP server'},
                  {tag: 'port', info: 'the port number on which the FTP server listens (optional - default: 22)'},
                  {tag: 'user', info: 'the login user name'},
                  {tag: 'password', info: 'the login password'},
                  {tag: 'location', info: 'the path to the directory'},
              ]},
              {protocol: 'SFTP', options: [
                  {tag: 'host', info: 'the hostname or ip-address of the FTP server'},
                  {tag: 'port', info: 'the port number on which the FTP server listens (optional - default: 22)'},
                  {tag: 'user', info: 'the login user name'},
                  {tag: 'password', info: 'the login password'},
                  {tag: 'location', info: 'the path to the directory'},
              ]},
              {protocol: 'GDRIVE', options: [
                  {tag: 'credentials_file', info: 'the file where the credentials for the Google Drive can be found'},
                  {tag: 'port', info: 'the port number on which the FTP server listens (optional - default: 22)'},
                  {tag: 'user', info: 'the login user name'},
                  {tag: 'password', info: 'the login password'},
                  {tag: 'location', info: 'the path to the directory'},
              ]}
          ]
          table_for data do
            column :protocol do |info|
              info[:protocol]
            end
            column :options do |info|
              table_for info[:options] do
                column :tag do |option|
                  option[:tag]
                end
                column :info do |option|
                  option[:info]
                end
              end
            end
          end

        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name, required: true
      f.input :protocol, required: true, collection: Teneo::DataModel::Storage::PROTOCOL_LIST
      f.hidden_field :lock_version
    end
    f.actions
  end

end
