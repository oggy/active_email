require 'active_email'
$:.unshift "#{RAILS_ROOT}/app/emails"
ActiveSupport::Dependencies.load_paths << "#{RAILS_ROOT}/app/emails"
ActiveEmail::Mailer.template_root = "#{RAILS_ROOT}/app/views/emails"
