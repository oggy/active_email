require 'easy_mailer/email_rat'
require 'easy_mailer/rspec/matchers'

ActiveSupport::TestCase.class_eval do
  include EasyMailer::RSpec::Matchers
end
