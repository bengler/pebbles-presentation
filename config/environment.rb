require File.expand_path('config/site.rb') if File.exists?('config/site.rb')

require "bundler"
Bundler.require

ENV['RACK_ENV'] ||= 'development'
set :environment, ENV['RACK_ENV'].to_sym

use Rack::CommonLogger

Pebblebed.config do
  # TODO: Make host centrally configurable and marshal to frontend
  host 'pebbles.o5.no'
  service :grove
end