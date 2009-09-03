require 'spec_helper'

describe "An ApplicationMailer subclass with a greeting email which requires a name" do
  describe ".new_email" do
    before do
      temporary_mailer :TestMailer do
        const_set(:Greeting, Class.new(Base::Email)).class_eval do
          attr_accessor :name
        end
      end
      make_template TestMailer, :greeting, "Hi, <%= name %>!"
    end

    describe "#deliver on the model" do
      it "should return true and send the email if the email validates" do
        model = TestMailer::Greeting.new(:name => 'Fred')
        model.deliver.should be_true
        ActionMailer::Base.deliveries.should have(1).email
      end
    end
  end

  describe "Email#deliver" do
    before do
      temporary_mailer :TestMailer do
        const_set(:Greeting, Class.new(Base::Email))
      end
      make_template TestMailer, :greeting, 'hi'
      @email = TestMailer::Greeting.new
    end

    def delivery
      ActionMailer::Base.deliveries.first
    end

    it "should pass the #to field to ActionMailer" do
      @email.to = ['to@example.com']
      @email.deliver.should be_true  # sanity check
      delivery.to.should == ['to@example.com']
    end

    it "should pass the #subject field to ActionMailer" do
      @email.subject = 'SUBJECT'
      @email.deliver.should be_true  # sanity check
      delivery.subject.should == 'SUBJECT'
    end

    it "should pass the #from field to ActionMailer" do
      @email.from = ['from@example.com']
      @email.deliver.should be_true  # sanity check
      delivery.from.should == ['from@example.com']
    end

    it "should pass the #cc field to ActionMailer" do
      @email.cc = ['cc@example.com']
      @email.deliver.should be_true  # sanity check
      delivery.cc.should == ['cc@example.com']
    end

    it "should pass the #bcc field to ActionMailer" do
      @email.bcc = ['bcc@example.com']
      @email.deliver.should be_true  # sanity check
      delivery.bcc.should == ['bcc@example.com']
    end

    it "should pass the #reply_to field to ActionMailer" do
      @email.reply_to = ['reply_to@example.com']
      @email.deliver.should be_true  # sanity check
      delivery.reply_to.should == ['reply_to@example.com']
    end

    it "should pass the #sent_on field to ActionMailer" do
      @email.sent_on = Time.parse('December 21, 2012 12:34')
      @email.deliver.should be_true  # sanity check
      delivery.date.should == Time.parse('December 21, 2012 12:34')
    end

    it "should pass the #content_type field to ActionMailer" do
      @email.content_type = 'text/rot13'
      @email.deliver.should be_true  # sanity check
      delivery.content_type.should == 'text/rot13'
    end

    it "should pass the #headers field to ActionMailer" do
      @email.headers = {'X-Mailer' => 'Spam Cannon'}
      @email.deliver.should be_true  # sanity check
      delivery.header_string('X-Mailer').should == 'Spam Cannon'
    end

    it "should pass the rendered template to ActionMailer as the body" do
      @email.deliver.should be_true  # sanity check
      delivery.body.should == 'hi'
    end
  end
end
