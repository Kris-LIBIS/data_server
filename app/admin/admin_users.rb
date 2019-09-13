require 'action_icons'

ActiveAdmin.register AdminUser do
  menu parent: 'Users', priority: 2

  config.sort_order = 'email_asc'
  config.batch_actions = false

  permit_params :email, :password, :password_confirmation, :lock_version

  index as: :grid, default: true do |object|
    # noinspection RubyResolve
    panel link_to(object.email, edit_resource_path(object)) do
      action_icons path: resource_path(object), actions: %i[edit delete]
    end
  end

  filter :email

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.hidden_field :lock_version
    end
    f.actions
  end

end
