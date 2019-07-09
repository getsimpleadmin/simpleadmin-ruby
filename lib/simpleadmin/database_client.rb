# frozen_string_literal: true

require 'singleton'

module Simpleadmin
  class DatabaseClient
    include Singleton

    attr_accessor :client

    def self.client
      instance.client
    end
  end
end
