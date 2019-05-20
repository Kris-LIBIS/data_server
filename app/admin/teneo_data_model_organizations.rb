ActiveAdmin.register Teneo::DataModel::Organization, as: 'Organization' do
menu priority: 2
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  config.sort_order = 'name_asc'

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
    actions
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
    f.inputs 'Organization info' do
      f.input :name, required: true
      f.input :description
      f.input :inst_code, required: true
      f.input :ingest_dir
    end

    f.inputs 'Assigned Users' do
      # noinspection RailsParamDefResolve
      f.has_many :memberships, heading: false, allow_destroy: true do |m|
        m.input :user, required: true
        m.input :role, required: true
      end
    end

    # f.inputs 'Storages' do
    #   # noinspection RailsParamDefResolve
    #   f.has_many :storages, heading: false, allow_destroy: true do |m|
    #     m.input :name, required: true
    #     m.input :protocol, collection: %w'NFS FTP SFTP GDRIVE', required: true
    #     m.input :options, as: :text, input_html: {class: 'jsoneditor-target'}
    #   end
    # end

    actions
  end


end
