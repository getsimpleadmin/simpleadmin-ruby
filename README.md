[![Build Status](https://secure.travis-ci.org/getsimpleadmin/simpleadmin.svg?branch=master)](http://travis-ci.org/getsimpleadmin/simpleadmin) [![codecov.io](https://codecov.io/github/getsimpleadmin/simpleadmin/coverage.svg?branch=master)](https://codecov.io/github/getsimpleadmin/simpleadmin?branch=master)[![Gem Version](https://badge.fury.io/rb/simpleadmin.svg)](https://rubygems.org/gems/simpleadmin)
# [SimpleAdmin](https://getsimpleadmin-staging.herokuapp.com/)

SimpleAdmin provides builder for administrative dashboards, it's fit for Web / Mobile / API. Cloud or your own servers, depends on your choice and requirements. 

All common admin dashboard tasks like content create / update / delete operations, charts, invite colleagues.

This is API Rack Application to connect your application with SimpleAdmin service.

[Example Application][demo]

## Requirements

- Ruby ~> 2.3

## Installation

![simple_admin](https://getsimpleadmin-staging.herokuapp.com/assets/demo-b3f2234a3a7b9a269e0d12febc0e4fe45c4150457b98affa50d2ff9dbe3460c2.jpg)

Add SimpleAdmin to your application's Gemfile:

```ruby
gem 'simpleadmin'
```

And then run:

```ruby
bundle install
```

## Configuration

Add the next line to your routes file to mount simpleadmin built-in routes:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount Simpleadmin::Application, at: 'simpleadmin'
end
```

Create initializer, add your secret key and restart server

```ruby
# config/initializers/simpleadmin.rb
ENV['SIMPLE_ADMIN_SECRET_KEY'] = 'SECRET_KEY'

Simpleadmin::Config.setup do |config|
    #  For Ruby on Rails, you don't need to define database credentials directly, 
    #  also when you deployed it on Heroku. In other cases define database 
    #  credentials using the syntax below
    config.database_credentials = {
       adapter: :postgres,
       database: 'demo_development'
    }
    
    # By default all tables permitted, but you can select what tables you want to use in the admin panel
    config.allowed_tables = ['users', 'orders']
   
    #  DSL to describe CRUD actions in an application. In Ruby on Rails, you don't need to define it 
    config.on_create = lambda do |model_class, resource_params|
      model_class.create(resource_params)
    end

    config.on_update = lambda do |model_class, resource_id, resource_params|
      model_class.find(resource_id).update(resource_params)
    end

    config.on_destroy = lambda do |model_class, resource_id|
      model_class.find(resource_id).destroy
    end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/getsimpleadmin/simpleadmin.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[demo]: https://getsimpleadmin-staging.herokuapp.com/demo/admin/customer/resources
