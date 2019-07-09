# frozen_string_literal: true

module Simpleadmin
  module Decorators
    module Fields
      class Base
        def initialize(table_name, table_field_name, resource: nil, resources: [], settings: [])
          @table_name, @table_field_name = table_name, table_field_name

          @settings = settings
          @resource = resource

          @resources = resources
        end

        def call
          raise NotImplementedError, 'Please follow the unified interface, add method #call'
        end

        private

        attr_reader :table_name, :table_field_name, :resource, :resources, :settings

        def model_by_table_name(table_name)
          model_class = table_name.classify.safe_constantize

          if model_class.nil?
            raise ArgumentError, "The model (#{table_name.classify}) does not exist"
          else
            model_class
          end
        end

        def setting_value_by_name(name)
          setting_data = settings.find { |setting| setting['column_name'] == name }
          setting_data['column_value']
        end
      end
    end
  end
end
