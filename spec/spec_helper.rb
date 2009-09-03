require 'fileutils'
require 'spec'
require 'mocha'
require 'active_record'  # For ActiveRecordBaseWithoutTable
require 'action_mailer'

require 'init'
require 'easy_mailer/email_rat'
require 'easy_mailer/rspec'
require 'helpers/temporary_directory'
require 'helpers/temporary_mailer'

PLUGIN_ROOT = File.dirname(__FILE__) + '/..'

ActionMailer::Base.delivery_method = :test

Spec::Runner.configure do |config|
  config.mock_with :mocha
  config.include Helpers::TemporaryDirectory
  config.include Helpers::TemporaryMailer
end

# So we don't have to qualify all our classes.
include EasyMailer
