# frozen_string_literal: true

require 'simpleadmin/decorators/fields_decorator'
require 'simpleadmin/database_client'

module Simpleadmin
  module Adapters
    # Base class to provide a unified interface for each adapter
    #
    # @since 1.0.0
    class Base
      def initialize(database_credentials:)
        @database_credentials = database_credentials
      end

      def tables
        raise NotImplementedError, 'Please follow the unified interface, add method #tables'
      end

      def table_columns(*_args)
        raise NotImplementedError, 'Please follow the unified interface, add method #table_columns'
      end

      def resources(*_args)
        raise NotImplementedError, 'Please follow the unified interface, add method #resources'
      end

      private

      attr_reader :database_credentials

      def order_asc?(order)
        order == 'asc'
      end

      def order_desc?(order)
        order == 'desc'
      end

      def model_class_by_table_name(name)
        name.classify.safe_constantize
      end

      def table_names
        return client.tables if Config.allowed_tables.include?(:all)

        Config.allowed_tables
      end
    end
  end
end
