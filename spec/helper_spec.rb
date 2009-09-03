require 'spec_helper'

describe Helper do
  before do
    temporary_mailer :TestMailer do
      email(:greeting){}
    end
    make_template TestMailer, :greeting, "<%= to.inspect %> | <%= from.inspect %>"
    @email = TestMailer.greeting_email({})
  end

  def delivery
    ActionMailer::Base.deliveries.first
  end

  it "should set let the template have access to methods on the email" do
    @email.to = ['to@example.com']
    @email.from = ['from@example.com']
    @email.deliver.should be_true
    delivery.body.should == '["to@example.com"] | ["from@example.com"]'
  end
end
