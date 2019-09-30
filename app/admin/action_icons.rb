# noinspection RubyResolve,RailsI18nInspection

require 'active_admin_patch'

def button_link(href:, title:, icon: nil, method: :get, data: {}, classes: [], params: {})
  options = {href: href, title: title}
  options[:href] += '?' + params.map { |k, v| "#{k}=#{v}" }.join('&') unless params.empty?
  options[:method] = method if method
  # options[:type] = :submit
  options[:data] = data if data
  options[:class] = classes.join(' ')
  value = icon ? fa_icon(icon.to_s) : title
  ref = options.delete :href
  # button(value, ref, options)
  # noinspection RubyResolve
  span class: 'button_link' do
    link_to value, ref, options
  end
end

def parent_info
  if (x = request.params.keys.find { |x| x =~ /^(.*)_id$/ })
    return {type: $1, id: request.params[x]}
  end
  nil
end

def back_path(info: nil, anchor: nil)
  params = []
  path = ['admin']
  return unless (info ||= parent_info)
  parent_type = info[:type]
  parent_id = info[:id]
  parent_resource = ActiveAdmin.application.namespaces[:admin].resources[parent_type.to_s.camelize]
  return unless parent_resource
  grand_parent_type = parent_resource.belongs_to_config&.target&.resource_name&.element
  if grand_parent_type
    parent_object = parent_resource.resource_class.find(parent_id)
    grand_parent_id = parent_object.send(grand_parent_type).id
    path << grand_parent_type
    params << grand_parent_id
  end
  path << parent_type
  params << parent_id
  path << 'path'
  # send(path.compact.join('_'), *params) + '/#' + anchor.to_s
  send(path.compact.join('_'), *params, anchor: anchor)
end

def back_button(anchor: nil)
  return unless (info = parent_info)
  button_link href: back_path(anchor: anchor), title: "back to #{info[:type]}", classes: ['back-button']
end

def new_button(object_type, resource_type = nil, action: 'new', method: :get, params: {}, values: {})
  path = [action, 'admin', object_type, resource_type, 'path'].compact.join '_'
  args = []
  args << request.params[:id] if resource_type
  args << values
  button_link href: send(path, *args),
              title: 'New', icon: 'plus-circle', classes: ['right-align'], method: method, params: params
end

def help_icon(message = nil)
  return if message.blank?
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

def list_for(resource:, parent_resource:)
  parent_resource.parameters_hash_for(resource.name, recursive: true).reduce({}) { |r, (k, v)|
    n = k.gsub(/^.*#/, '')
    n = "<b>#{n}</b>" if v[:export]
    x = v[:data_type] == 'bool' ? v[:default] == 't' : v[:default]
    x = "\u180e" if x.nil? || x.blank?
    r[n] = x
    r
  }
end

class ParameterTab < Arbre::Component
  builder_method :parameter_tab

  def build(resource:, message:)
    path_name = resource.class.name.split('::').last.underscore
    table_for resource.parameters.order(:id) do
      column :references, as: :tags do |param|
        param.targets.map(&:reference_name)
      end
      column :export_name do |param|
        param.name if param.export
      end
      # noinspection RubyResolve
      column :default
      column :description
      column '' do |param|
        help_icon param.help
        action_labels = %i[edit delete]
        action_labels.delete(:delete) if param.targets.count + param.sources.count > 0
        # noinspection RubyResolve
        action_icons path: send("admin_#{path_name}_parameter_path", resource, param), actions: action_labels
      end
    end
    div message.html_safe
    data = []
    resource.child_parameters(export_only: true, unmapped_only: true).each do |param|
      h = param.to_hash
      h[:reference] = param.with_parameters.name
      data << h
    end
    table_for data do
      column resource.parameter_children.first.class.name.split('::').last do |row|
        row[:reference]
      end
      column :name
      column :data_type
      column :default
      column :description
      column '' do |row|
        div class: 'right-align' do
          help_icon row[:help]
          new_button path_name, :parameter,
                     values: {
                         teneo_data_model_parameter: {
                             name: row[:name],
                             # target_list: ["", "#{row[:reference]}##{row[:name]}"],
                             with_parameters_type: resource.class.name,
                             with_parameters_id: resource.id
                         }
                     }
        end
      end
    end unless data.empty?
  end

end

class ParameterDefTab < Arbre::Component
  builder_method :parameter_def_tab

  def build(resource:)
    path_name = resource.class.name.split('::').last.underscore
    table_for resource.parameters.order(:id) do
      column :name
      column :data_type
      column :constraint
      column :default
      column :description
      column '' do |param|
        div class: 'right-align' do
          help_icon param.help
          action_labels = %i[edit delete]
          action_labels.delete(:delete) if param.targets.count + param.sources.count > 0
          # noinspection RubyResolve
          action_icons path: send("admin_#{path_name}_parameter_path", resource, param), actions: action_labels
        end
      end
    end
    new_button path_name, :parameter,
               values: {
                   teneo_data_model_parameter: {
                       with_parameters_type: resource.class.name,
                       with_parameters_id: resource.id
                   }
               }
  end

end
