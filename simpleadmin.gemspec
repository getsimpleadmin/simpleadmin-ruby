# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simpleadmin/version'

Gem::Specification.new do |spec|
  spec.name        = 'simpleadmin'
  spec.version     = Simpleadmin::VERSION
  spec.authors     = ['Dmitriy Strukov']
  spec.email       = ['dmitriy.strukov@outlook.com']

  spec.homepage    = 'https://getsimpleadmin.com'
  spec.summary     = 'SimpleAdmin - Dashboard for modern applications without wasting time'
  spec.description = 'SimpleAdmin - Dashboard for modern applications without wasting time'

  spec.license = 'MIT'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec'

  spec.add_dependency 'bcrypt'
  spec.add_dependency 'rack-app'
  spec.add_dependency 'sequel'
end
