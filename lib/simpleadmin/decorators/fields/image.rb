# frozen_string_literal: true

module Simpleadmin
  module Decorators
    module Fields
      class Image < Base
        def call
          record = model_by_table_name(table_name).find(resource[:id])

          if record.public_send(table_field_name).respond_to?(:url)
            record.public_send(table_field_name).url
          else
            raise TypeError, "The column #{table_field_name} doesn't support image format"
          end
        end
      end
    end
  end
end
