require 'active_support/test_case'
require 'active_email/email_rat'
require 'active_email/rspec/matchers'

ActiveSupport::TestCase.class_eval do
  include ActiveEmail::RSpec::Matchers
end

Spec::Runner.configure do |c|
  c.before{ActionMailer::Base.deliveries.clear}
end
