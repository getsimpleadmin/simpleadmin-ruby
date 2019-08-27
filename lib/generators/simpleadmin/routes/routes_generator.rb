# frozen_string_literal: true

require 'rails/generators/base'

module Simpleadmin
  module Generators
    class RoutesGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def insert_simpleadmin_routes
        route(simpleadmin_routes)
      end

      def simpleadmin_routes
        ERB.new(File.read(routes_file_path)).result(binding)
      end

      def routes_file_path
        File.expand_path(find_in_source_paths('routes.rb'))
      end
    end
  end
end
