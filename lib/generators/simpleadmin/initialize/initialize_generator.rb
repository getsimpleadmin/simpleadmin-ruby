# frozen_string_literal: true

require 'rails/generators/named_base'

module Simpleadmin
  module Generators
    class InitializeGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      def copy_initializer_file
        copy_file 'simpleadmin.rb', "config/initializers/#{file_name}.rb"
      end
    end
  end
end
