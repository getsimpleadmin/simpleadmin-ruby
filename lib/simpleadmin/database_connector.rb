# frozen_string_literal: true

require 'simpleadmin/adapters/base'
require 'simpleadmin/adapters/postgres'

module Simpleadmin
  # Connector service that handles different databases to provide unified API endpoints
  #
  # @since 1.0.0
  #
  class DatabaseConnector
    ADAPTERS_MAPPER = {
      postgresql: Adapters::Postgres,
      postgres: Adapters::Postgres
    }.freeze

    def initialize(database_credentials:)
      @database_credentials = database_credentials
    end

    def client
      @client ||= adapter.new(database_credentials: database_credentials)
    end

    private

    attr_reader :database_credentials

    def adapter
      if database_credentials.is_a?(String)
        adapter_name = ADAPTERS_MAPPER.keys.find { |adapter_key| database_credentials.include?(adapter_key.to_s) }

        ADAPTERS_MAPPER[adapter_name]
      elsif database_credentials.is_a?(Hash)
        adapter_class = ADAPTERS_MAPPER[database_credentials[:adapter]]
        raise ArgumentError, 'Invalid adapter name or adapter not exist' if adapter_class.nil?

        adapter_class
      end
    end
  end
end
