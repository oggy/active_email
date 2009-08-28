require 'spec_helper'

describe "An ApplicationMailer subclass with a greeting email which requires a name" do
  class TestMailer < EasyMailer::Base
    email :greeting do
      attr_accessor :name
      validates_presence_of :name
    end

    # read templates from spec dir
    self.template_root = "#{PLUGIN_ROOT}/spec/views"
  end

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe ".greeting_email" do
    it "should return #email model" do
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
end
