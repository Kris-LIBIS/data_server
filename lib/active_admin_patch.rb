# frozen_string_literal: true

require 'active_admin/resource_controller/polymorphic_routes'

module ActiveAdmin
  class ResourceController < BaseController
    module PolymorphicRoutes

      private

      alias_method :to_named_resource_orig, :to_named_resource

      def to_named_resource(record)
        if record.is_a?(parent.class) && active_admin_config.belongs_to_config.nil?
          resource = active_admin_config.namespace.resource_for(record.class)
          return ActiveAdmin::Model.new(resource, record) if resource
        end

        to_named_resource_orig(record)
      end

    end
  end
end
