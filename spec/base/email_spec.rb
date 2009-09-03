require 'spec_helper'

describe Base::Email do
  describe "validations" do
    before do
      temporary_mailer :TestMailer do
        email :greeting do
          attr_accessible :name
          validates_presence_of :name
        end
      end
    end

    it "should work like ActiveRecord" do
      model = TestMailer.greeting_email(:name => '')
      model.should_not be_valid
      model.errors.on(:name).should_not be_nil
    end

    it "should prevent the email being sent if the email does not validate" do
      model = TestMailer.greeting_email(:name => '')
      model.deliver.should be_false
      model.errors.on(:name).should_not be_nil
      ActionMailer::Base.deliveries.should be_empty
    end
  end
end
