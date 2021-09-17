# frozen_string_literal: true

source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'scanf'

gem 'rubocop', require: false, groups: %i[development test]
gem 'rubocop-rspec', require: false, groups: %i[development test]
gem 'rubocop-performance', require: false, groups: %i[development test]

group :test do
  gem 'rspec'
  gem 'simplecov', require: false
end
