$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'codebreaker_rack_app'

require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

module CodebreakerRackApp
  include Rack::Test::Methods
  def app() RackSystem end
end

RSpec.configure { |c| c.include CodebreakerRackApp }
