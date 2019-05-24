# noinspection RubyResolve,RailsI18nInspection
class ActionIcons < Arbre::Component
  builder_method :action_icons

  def build(path:, actions: [:view, :edit, :delete])
    div class: 'right-align' do
      localizer = ActiveAdmin::Localizers.resource(active_admin_config)
      button_link(href: path, title: 'View', icon: :eye) if actions.include? :view
      button_link(href: "#{path}/edit", title: 'Edit', icon: :edit) if actions.include? :edit
      button_link(href: path, title: 'Delete', icon: :trash, method: :delete,
                  data: {confirm: localizer.t(:delete_confirmation)}) if actions.include? :delete
    end
  end

  def button_link(href:, title:, icon:, method: nil, data: nil)
    options = {href: href, title: title}
    options[:method] = method if method
    options[:data] = data if data
    a options do
      button {fa_icon(icon.to_s)}
    end
  end

end
