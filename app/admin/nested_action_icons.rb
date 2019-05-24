require 'action_icons'

class NestedActionIcons < Arbre::Component
  builder_method :nested_action_icons

  def build(*resources, actions: [:view, :edit, :delete], path_method: 'resource_path')
    div style: 'display: block; float: right;' do
      # noinspection RubyResolve
      span do
        link_to fa_icon('eye', title: 'View'), send(path_method, *resources)
      end if actions.include? :view
      # noinspection RubyResolve
      span do
        link_to fa_icon('edit', title: 'Edit'), send("edit_#{path_method}", *resources)
      end if actions.include? :edit
      # noinspection RubyResolve
      span do
        localizer = ActiveAdmin::Localizers.resource(active_admin_config)
        # noinspection RailsI18nInspection
        link_to fa_icon('trash', title: 'Delete'), send(path_method, *resources), method: :delete,
                data: {confirm: localizer.t(:delete_confirmation)}
      end if actions.include? :delete
    end
  end

end
