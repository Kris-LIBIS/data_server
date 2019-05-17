ActiveAdmin.register LoginUser do
  menu parent: 'Users', priority: 1

  permit_params :email, :password, :password_confirmation
  config.sort_order = 'id_asc'

  index do
    selectable_column
    id_column
    column :email
    actions
  end

  filter :email

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
