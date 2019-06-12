# noinspection RubyResolve,RailsI18nInspection

def button_link(href:, title:, icon: nil, method: :get, data: {}, classes: [], params: {})
  options = {href: href, title: title}
  options[:href] += '?' + params.map {|k, v| "#{k}=#{v}"}.join('&') unless params.empty?
  options[:method] = method if method
  # options[:type] = :submit
  options[:data] = data if data
  options[:class] = classes.join(' ')
  value = icon ? fa_icon(icon.to_s) : title
  ref = options.delete :href
  # button(value, ref, options)
  span class: 'button_link' do
    link_to value, ref, options
  end
end

def back_button(object_type, parent_type = nil)
  object_id = request.params["#{object_type}_id"]
  params = []
  if parent_type
    object_class = "Teneo::DataModel::#{object_type.to_s.camelize}".constantize
    object = object_class.find(object_id)
    params << object.send(parent_type).id
  end
  params << object_id
  button_link href: send(['admin', parent_type, object_type, 'path'].compact.join('_'), *params),
              title: "back to #{object_type}", classes: ['back-button']
end

def new_button(object_type, resource_type = nil, action: 'new', method: :get, params: {})
  path = [action, 'admin', object_type, resource_type, 'path'].compact.join '_'
  args = []
  args << request.params[:id] if resource_type
  button_link href: send(path, *args),
              title: 'New', icon: 'plus-circle', classes: ['right-align'], method: method, params: params
end

def help_icon(message = nil)
  return unless message
  # noinspection RubyResolve
  span class: 'button_link' do
    a onclick: "alert('#{message}');" do
      fa_icon 'question-circle'
    end
  end
end

# noinspection RailsI18nInspection
class ActionIcons < Arbre::Component
  builder_method :action_icons

  def build(path:, actions: [:view, :edit, :delete])
    div class: 'right-align' do
      localizer = ActiveAdmin::Localizers.resource(active_admin_config)
      button_link(href: path, title: 'View', icon: 'eye') if actions.include? :view
      button_link(href: "#{path}/edit", title: 'Edit', icon: 'edit') if actions.include? :edit
      button_link(href: path, title: 'Delete', icon: 'trash', method: :delete,
                  data: {confirm: localizer.t(:delete_confirmation)}) if actions.include? :delete
    end
  end

end
