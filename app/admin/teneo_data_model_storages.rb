# frozen_string_literal: true
require 'nested_action_icons'

ActiveAdmin.register Teneo::DataModel::Storage, as: 'Storage' do
  menu false

  belongs_to :organization, parent_class: Teneo::DataModel::Organization

  config.sort_order = 'name_asc'
  config.batch_actions = false

  # actions :new, :show, :edit, :destroy

  # controller do
  #   # noinspection RubySuperCallWithoutSuperclassInspection,RubyBlockToMethodReference,RubyResolve
  #   def create; super {collection_url};end
  #
  #   # noinspection RubyBlockToMethodReference,RubySuperCallWithoutSuperclassInspection,RubyResolve
  #   def update; super {collection_url};end
  # end

  permit_params :name, :protocol, :options, :organization_id, :lock_Version

  filter :name
  filter :protocol, as: :select, collection: Teneo::DataModel::Storage::PROTOCOL_LIST

  index do
    back_button :organization
    column :name
    column :protocol
    column :options
    actions defaults: false do |object|
      # noinspection RubyBlockToMethodReference,RubyResolve
      action_icons path: resource_path(object), actions: %i[edit delete]
    end
  end

  show do

    # noinspection RubyResolve
    back_button :organization

    attributes_table do
      row :name
      row :protocol
      row :options
      # noinspection RubyResolve
    end
  end

  form do |f|
    columns do
      column do
        f.inputs do
          f.input :name, required: true
          f.input :protocol, required: true, collection: Teneo::DataModel::Storage::PROTOCOL_LIST
          f.input :options, as: :jsonb
          f.hidden_field :lock_version
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
    f.actions
  end
end
