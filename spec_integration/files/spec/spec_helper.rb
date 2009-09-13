ENV["RAILS_ENV"] ||= 'test'
require 'config/environment'

require 'spec/rails'
require 'webrat'
require 'active_email/rspec'

Webrat.configure do |config|
  config.mode = :rails
end

module ActionController::Integration::Runner
  def method_missing_with_proper_delegation(name, *args, &block)
    reset! unless @integration_session
    if @integration_session.respond_to?(name)
      method_missing_without_proper_delegation(name, *args, &block)
    else
      super
    end
  end
  alias_method_chain :method_missing, :proper_delegation
end
