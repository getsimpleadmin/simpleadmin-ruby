# frozen_string_literal: true

require 'rails/generators/base'

module Simpleadmin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def run_initialize_generator
        call_generator 'simpleadmin:initialize', 'simpleadmin'
      end

      def run_routes_generator
        call_generator 'simpleadmin:routes'
      end

      private

      def call_generator(generator, *args)
        Rails::Generators.invoke(generator, args, behavior: behavior)
      end
    end
  end
end
