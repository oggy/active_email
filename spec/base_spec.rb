require 'spec_helper'

describe "An ApplicationMailer subclass with a greeting email which requires a name" do
  before do
    temporary_mailer :TestMailer do
      email :greeting do
        attr_accessor :name
        validates_presence_of :name
        attr_accessible :recipients
      end
    end
    make_template TestMailer, :greeting, "Hi, <%= name %>!"
  end

  describe ".greeting_email" do
    it "should return an #email model" do
      model = TestMailer.greeting_email(:name => 'Fred')
      model.should be_a(TestMailer::Email)
    end

    it "should validate the name given to the email" do
      model = TestMailer.greeting_email(:name => '')
      model.should_not be_valid
      model.errors.on(:name).should_not be_nil
    end

    describe "#deliver on the model" do
      it "should return true and send the email if the email validates" do
        model = TestMailer.greeting_email(:name => 'Fred')
        model.deliver.should be_true
        ActionMailer::Base.deliveries.should have(1).email
      end

      it "should not send the email if the email does not validate" do
        model = TestMailer.greeting_email(:name => '')
        model.deliver.should be_false
        model.errors.on(:name).should_not be_nil
        ActionMailer::Base.deliveries.should be_empty
      end
    end
  end

  describe "Email#deliver" do
    def email
      ActionMailer::Base.deliveries.first
    end

    it "should set the to address" do
      model = TestMailer.greeting_email(:recipients => 'fred@example.com', :name => 'Fred')
      model.deliver.should be_true
      email.to.should == ['fred@example.com']
    end

    it "should set let the template have access to methods on the email" do
      model = TestMailer.greeting_email(:name => 'Fred')
      model.deliver.should be_true
      email.body.should == 'Hi, Fred!'
    end
  end
end
