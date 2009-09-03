require 'active_support/test_case'
require 'easy_mailer/email_rat'
require 'easy_mailer/rspec/matchers'

ActiveSupport::TestCase.class_eval do
  include EasyMailer::RSpec::Matchers
end

Spec::Runner.configure do |c|
  c.before{ActionMailer::Base.deliveries.clear}
end
