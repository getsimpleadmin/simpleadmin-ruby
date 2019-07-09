# frozen_string_literal: true

module Simpleadmin
  module Decorators
    module Fields
      class BelongsTo < Base
        def call
          association_ids = resources.map { |resource| resource[table_field_name] }

          association_values(association_ids).each do |id, association_value|
            resource = resources.find { |resource_attributes| resource_attributes['id'] == id }

            resource[table_field_name] = {
              association_name: setting_value_by_name('model_klass_name'),
              association_value: association_value,
              origin_value: resource[table_field_name]
            }
          end

          resources
        end

        private

        def association_values(association_ids)
          model_by_table_name(setting_value_by_name('model_klass_name'))
            .where(id: association_ids)
            .pluck(:id, setting_value_by_name('model_column_name'))
        end
      end
    end
  end
end
