require 'spec'
require 'mocha'
require 'action_mailer'

require 'init'

PLUGIN_ROOT = File.dirname(__FILE__) + '/..'

ActionMailer::Base.delivery_method = :test

module SpecHelper
end

Spec::Runner.configure do |config|
  config.mock_with :mocha
  config.include SpecHelper
end

# So we don't have to qualify all our classes.
include EasyMailer
