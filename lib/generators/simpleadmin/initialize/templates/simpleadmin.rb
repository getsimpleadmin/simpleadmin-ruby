# frozen_string_literal: true

ENV['SIMPLE_ADMIN_SECRET_KEY'] = 'SECRET_KEY'

Simpleadmin::Config.setup do |config|
  #  For Ruby on Rails, you don't need to define database credentials directly,
  #  also when you deployed it on Heroku. In other cases define database
  #  credentials using the syntax below
  #
  # config.database_credentials = {
  #  adapter: :postgres,
  #  database: 'demo_development'
  # }

  # You can select what tables you want to use in the admin panel
  # config.allowed_tables = ['users', 'orders']

  #  DSL to describe CRUD actions in an application. In Ruby on Rails, you don't need to define it
  #
  # config.on_create = lambda do |model_class, resource_params|
  #   model_class.create(resource_params)
  # end

  # config.on_update = lambda do |model_class, resource_id, resource_params|
  #   model_class.find(resource_id).update(resource_params)
  # end

  # config.on_destroy = lambda do |model_class, resource_id|
  #   model_class.find(resource_id).destroy
  # end
end
