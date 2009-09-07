require 'easy_mailer'
$:.unshift "#{RAILS_ROOT}/app/emails"
ActiveSupport::Dependencies.load_paths << "#{RAILS_ROOT}/app/emails"
EasyMailer::Mailer.template_root = "#{RAILS_ROOT}/app/views/emails"
