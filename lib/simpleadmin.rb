# frozen_string_literal: true

require 'rack/app'
require 'sequel'
require 'bcrypt'

require 'simpleadmin/version'
require 'simpleadmin/config'
require 'simpleadmin/database_connector'

# Administrative dashboard without wasting time
#
# @since 1.0.0
#
# @see https://getsimpleadmin.com

module Simpleadmin
  # API endpoints for integration with cloud version of getsimpleadmin.com
  #
  # This is used, Rack conception to connect it in any popular web frameworks
  # like Ruby on Rails, Hanami, Sinatra and etc.
  #
  # @since 1.0.0
  #
  # @example
  #
  #  # config/routes.rb
  #  Rails.application.routes.draw do
  #    mount Simpleadmin::Application, at: 'simpleadmin'
  #  end
  class Application < Rack::App
    WIDGETS = %w[quantity week_statistic].freeze

    before { respond_forbidden! if secret_key_invalid? }
    before { respond_forbidden! unless current_path?('/v1/tables') || allowed_table? }

    namespace '/v1' do
      get '/widgets/:widget_name' do
        respond_forbidden!(message: 'Nonexistent widget') unless WIDGETS.include?(params['widget_name'])

        client.public_send(params['widget_name'], params['table_name'])
      end

      get '/tables' do
        client.tables
      end

      get '/tables/:table_name' do
        client.table_columns(params['table_name'])
      end

      get '/resources' do
        client.resources(params.values_at('table_name', 'table_fields', 'per_page',
                                          'page', 'query', 'model_attributes', 'sort'))
      end

      get '/resources/:id' do
        client.resource(params['id'], params['table_name'], params['table_fields'])
      end

      post '/resources' do
        client.create_resource(request_body_params['table_name'], request_body_params['resource'])
      end

      patch '/resources/:id' do
        client.update_resource(request_body_params['table_name'], params['id'], request_body_params['resource'])
      end

      delete '/resources/:id' do
        client.destroy_resouce(request_body_params['table_name'], params['id'])
      end
    end

    private

    def client
      @client ||= connector.client
    end

    def respond_forbidden!(message: 'Forbidden')
      response.status = 403
      response.write(message)

      finish!
    end

    def request_body_params
      @request_body_params ||= Rack::Utils.parse_nested_query(request.body.read)
    end

    def connector
      @connector ||= DatabaseConnector.new(
        database_credentials: Config.database_credentials
      )
    end

    def allowed_table?
      Config.allowed_table?(params['table_name'] || request_body_params['table_name'])
    end

    def secret_key_invalid?
      BCrypt::Password.new(request.get_header('HTTP_SIMPLEADMIN_SECRET_KEY')) != ENV['SIMPLE_ADMIN_SECRET_KEY']
    end

    def current_path?(path)
      request.path_info == path
    end
  end
end
