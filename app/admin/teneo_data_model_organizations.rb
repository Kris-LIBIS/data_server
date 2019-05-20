# frozen_string_literal: true
require 'action_icons'

ActiveAdmin.register Teneo::DataModel::Organization, as: 'Organization' do
  menu priority: 2

  config.sort_order = 'name_asc'
  config.batch_actions = false

  filter :name
  filter :description
  filter :inst_code

  permit_params :name, :description, :inst_code, :ingest_dir, :lock_version,
                memberships_attributes: [:id, :_destroy, :organization_id, :role_id, :user_id],
                storage_attributes: [:id, :_destroy, :name, :protocol, :options]

  index do
    column :name
    column :description
    column :inst_code
    actions defaults: false do |user|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons user
    end
  end

  show do
    columns do
      column span: 2 do
        attributes_table do
          row :name
          row :description
          row :inst_code
          row :ingest_dir
        end

        # noinspection RubyResolve
        panel 'Ingest Agreements' do
          table_for organization.ingest_agreements do
            column :name
          end
        end

      end
      column do

        # noinspection RubyResolve
        panel 'Assigned users' do
          table_for organization.memberships do
            column :user
            column :role
          end
        end

        # noinspection RubyResolve
        panel 'Storage' do
          table_for organization.storages do
            column :name
            column :protocol
          end
        end

      end
    end


  end

  form do |f|
    tabs do

      tab 'Organization' do
        columns do
          column do
            f.inputs 'Info' do
              f.input :name, required: true
              f.input :description
              f.input :inst_code, required: true
              f.input :ingest_dir
            end
          end
          column do
            f.inputs 'Assigned Users' do
              # noinspection RailsParamDefResolve
              f.has_many :memberships, heading: false, allow_destroy: true do |m|
                m.input :user, required: true
                m.input :role, required: true
              end
            end
          end
        end
      end

      tab 'Storages' do
        columns do

          column do
            f.inputs 'Storages' do
              # noinspection RailsParamDefResolve
              f.has_many :storages, heading: false, allow_destroy: true do |m|
                m.input :name, required: true
                m.input :protocol, collection: %w'NFS FTP SFTP GDRIVE', required: true
                m.input :options, as: :jsonb
              end
            end
          end

          column do
            # noinspection RubyResolve
            panel :help do
              div do
                "The options field configures the storage for a given protocol. The content of the options field " +
                    "should be different, depending on the protocol choosen:".html_safe
              end

              data = [
                  {protocol: 'NFS', options: [{tag: 'location', info: 'the path to the directory'}]},
                  {protocol: 'FTP', options: [
                      {tag: 'host', info: 'the hostname or ip-address of the FTP server'},
                      {tag: 'port', info: 'the port number on which the FTP server listens (optional - default: 22)'},
                      {tag: 'user', info: 'the login user name'},
                      {tag: 'password', info: 'the login password'},
                  ]},
                  {protocol: 'SFTP', options: [
                      {tag: 'host', info: 'the hostname or ip-address of the FTP server'},
                      {tag: 'port', info: 'the port number on which the FTP server listens (optional - default: 22)'},
                      {tag: 'user', info: 'the login user name'},
                      {tag: 'password', info: 'the login password'},
                  ]},
                  {protocol: 'GDRIVE', options: [
                      {tag: 'credentials_file', info: 'the file where the credentials for the Google Drive can be found'},
                      {tag: 'port', info: 'the port number on which the FTP server listens (optional - default: 22)'},
                      {tag: 'user', info: 'the login user name'},
                      {tag: 'password', info: 'the login password'},
                  ]}
              ]
              table_for data do
                column :protocol do |data|
                  data[:protocol]
                end
                column :options do |data|
                  table_for data[:options] do
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

      tab 'Ingest Agreements' do
      end

    end
    actions
  end


end
