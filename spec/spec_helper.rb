require 'spec'
require 'mocha'
require 'action_mailer'

require 'init'

module SpecHelper
end

Spec::Runner.configure do |config|
  config.mock_with :mocha
  config.include SpecHelper
end

# So we don't have to qualify all our classes.
include EasyMailer
