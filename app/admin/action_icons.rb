class ActionIcons < Arbre::Component
  builder_method :action_icons

  def build(path:, actions: [:view, :edit, :delete])
    div class: 'right-align' do
      # noinspection RubyResolve
      button do
        link_to fa_icon('eye', title: 'View'), path
      end if actions.include? :view
      # noinspection RubyResolve
      button do
        link_to fa_icon('edit', title: 'Edit'), "#{path}/edit"
      end if actions.include? :edit
      # noinspection RubyResolve
      button do
        localizer = ActiveAdmin::Localizers.resource(active_admin_config)
        # noinspection RailsI18nInspection
        link_to fa_icon('trash', title: 'Delete'), path, method: :delete,
                data: {confirm: localizer.t(:delete_confirmation)}
      end if actions.include? :delete
    end
  end

end
