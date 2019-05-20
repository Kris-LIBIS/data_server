ActiveAdmin.register LoginUser do
  menu parent: 'Users', priority: 1

  config.sort_order = 'email_asc'
  config.batch_actions = false

  permit_params :email, :password, :password_confirmation, :lock_version

  index as: :grid, default: true do |user|
    # noinspection RubyResolve
    panel link_to(user.email, edit_resource_path(user)) do
      action_icons user, [:edit, :delete]
    end
  end

  filter :email

  form title: proc {resource.user_data&.name || resource.email} do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.hidden_field :lock_version
      text_field :id, label: 'User name' do
        resource.user_data&.name
      end
    end
    f.actions
  end

end
