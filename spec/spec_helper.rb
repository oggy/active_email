require 'fileutils'
require 'spec'
require 'mocha'
require 'active_record'  # For ActiveRecordBaseWithoutTable
require 'action_mailer'

require 'active_email'
require 'active_email/rspec'
require 'helpers/temporary_directory'
require 'helpers/temporary_email_class'

PLUGIN_ROOT = File.dirname(__FILE__) + '/..'

ActionMailer::Base.delivery_method = :test

Spec::Runner.configure do |config|
  config.mock_with :mocha
  config.include Helpers::TemporaryDirectory
  config.include Helpers::TemporaryEmailClass
end

# So we don't have to qualify all our classes.
include ActiveEmail
