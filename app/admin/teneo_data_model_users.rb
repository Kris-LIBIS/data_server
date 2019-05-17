# noinspection RubyResolve
ActiveAdmin.register Teneo::DataModel::User, as: 'User' do
  menu priority: 1
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

  config.sort_order = 'email_asc'
  config.batch_actions = false

  permit_params :email, :first_name, :last_name,
                memberships_attributes: [:id, :_destroy, :organization_id, :role, :user_id]

  filter :organizations
  filter :roles
  filter :first_name_or_last_name_cont, as: :string, label: 'Name'
  filter :email

  index do
    column :email, link: true
    column :first_name
    column :last_name
    actions
  end

  show do
    columns do
      column span: 2 do
        attributes_table do
          row :email
          row :first_name
          row :last_name
        end
      end
      column do
        # noinspection RubyResolve
        panel 'User Roles' do
          table_for user.memberships do
            column :organization
            column :role
          end
        end
      end
    end

  end

  form do |f|
    f.inputs 'User info' do
      f.input :email
      f.input :first_name
      f.input :last_name
    end

    f.inputs 'Membership info' do
      # noinspection RailsParamDefResolve
      f.has_many :memberships, heading: false, allow_destroy: true do |m|
        m.input :organization, required: true
        m.input :role, required: true, collection: %w(uploader ingester admin)
      end
    end

    actions
  end

end
