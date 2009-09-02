require 'spec'
require 'mocha'
require 'active_record'  # For ActiveRecordBaseWithoutTable
require 'action_mailer'

require 'init'
require 'easy_mailer/email_rat'
require 'easy_mailer/rspec'

PLUGIN_ROOT = File.dirname(__FILE__) + '/..'

require 'lib/test_mailer'

ActionMailer::Base.delivery_method = :test

module SpecHelper
  def self.included(base)
    base.before{clear_deliveries}
  end

  def clear_deliveries
    ActionMailer::Base.deliveries.clear
  end
end

Spec::Runner.configure do |config|
  config.mock_with :mocha
  config.include SpecHelper
end

# So we don't have to qualify all our classes.
include EasyMailer
