# frozen_string_literal: true

require 'simpleadmin/decorators/fields/base'
require 'simpleadmin/decorators/fields/image'
require 'simpleadmin/decorators/fields/belongs_to'

module Simpleadmin
  module Decorators
    module FieldsDecorator
      SINGLE_RESOURCE_FIELDS_MAPPER = {
        'image' => Fields::Image
      }.freeze

      MULTIPLE_RESOURCE_FIELDS_MAPPER = {
        'belongs_to' => Fields::BelongsTo
      }.freeze

      def call(resources, table_name, table_fields)
        resources = map_single_resource_fields(table_name, table_fields, resources)
        resources = map_multiple_resource_fields(table_name, table_fields, resources) if multiple_table_fields_exists?(table_fields)

        resources
      end

      module_function :call

      private

      def map_multiple_resource_fields(table_name, table_fields, resources)
        multiple_table_fields = table_fields.select do |table_field|
          MULTIPLE_RESOURCE_FIELDS_MAPPER.keys.include?(table_field['field_type'])
        end

        multiple_table_fields.each do |table_field|
          table_field_name, table_field_type, table_field_settings = *table_field.values
          field_class = MULTIPLE_RESOURCE_FIELDS_MAPPER[table_field_type]

          resources = field_class.new(table_name, table_field_name,
                                      resources: resources,
                                      settings: table_field_settings).call
        end

        resources
      end

      module_function :map_multiple_resource_fields

      def map_single_resource_fields(table_name, table_fields, resources)
        resources.map do |resource|
          resource_attributes = {}

          table_fields.each do |table_field|
            table_field_name, table_field_type = *table_field.values

            if table_field_match?(table_field_type)
              field_class = SINGLE_RESOURCE_FIELDS_MAPPER[table_field_type]

              resource_attributes[table_field_name] = field_class.new(table_name, table_field_name,
                                                                      resource: resource).call
            else
              resource_attributes[table_field_name] = resource[table_field_name.to_sym]
            end
          end

          resource_attributes
        end
      end

      module_function :map_single_resource_fields

      def multiple_table_fields_exists?(table_fields)
        table_fields.any? { |table_field| MULTIPLE_RESOURCE_FIELDS_MAPPER.keys.include?(table_field['field_type']) }
      end

      module_function :multiple_table_fields_exists?

      def table_field_match?(table_field_type)
        SINGLE_RESOURCE_FIELDS_MAPPER.key?(table_field_type)
      end

      module_function :table_field_match?
    end
  end
end
