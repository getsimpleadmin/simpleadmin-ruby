# frozen_string_literal: true

require 'singleton'

module Simpleadmin
  # Configuration storage to customize allowed tables, to choose a database adapter and name
  #
  # @since 1.0.0
  #
  # @example
  #
  #   Simpleadmin::Config.setup do |config|
  #      config.database_credentials = {
  #        adapter: :postgres,
  #        database: 'squiz_development'
  #      }
  #
  #     config.allowed_tables = ['users']          # Allowed tables
  #     # config.allowed_tables = [:all]           # Allow all tables
  #
  #     config.on_create = lambda do |model_class, resource_params|
  #       model_class.create(resource_params)
  #     end
  #
  #     config.on_update = lambda do |model_class, resource_id, resource_params|
  #       model_class.find(resource_id).update(resource_params)
  #     end
  #
  #     config.on_destroy = lambda do |model_class, resource_id|
  #       model_class.find(resource_id).destroy
  #     end
  #   end
  class Config
    DEFAULT_TABLE_SCHEMAS = ['public'].freeze

    include Singleton

    attr_accessor :table_schemas, :database_credentials, :allowed_tables, :client
    attr_accessor :on_create, :on_update, :on_destroy

    class << self
      def setup
        yield(instance)
      end

      def allowed_table?(table_name)
        return true if allowed_tables.include?(:all)

        allowed_tables.include?(table_name)
      end

      def allowed_tables
        instance.allowed_tables || [:all]
      end

      def database_credentials
        return ENV['DATABASE_URL'] unless ENV['DATABASE_URL'].nil?

        if defined?(Rails)
          database_configuration = Rails.configuration.database_configuration[Rails.env]

          {
            database: database_configuration['database'],
            username: database_configuration['username'],
            password: database_configuration['password'],
            adapter: database_configuration['adapter'].to_sym
          }
        else
          instance.database_credentials
        end
      end

      def on_create
        instance.on_create || ->(model_class, resource_params) { model_class.create(resource_params) }
      end

      def on_update
        instance.on_update || ->(model_class, resource_id, resource_params) { model_class.find(resource_id).update(resource_params) }
      end

      def on_destroy
        instance.on_destroy || ->(model_class, resource_id) { model_class.find(resource_id).destroy }
      end

      def table_schemas
        instance.table_schemas || DEFAULT_TABLE_SCHEMAS
      end
    end
  end
end
