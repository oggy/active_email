require 'spec_helper'

describe EmailRat do
  before do
    temporary_mailer :TestMailer do
      const_set(:Greeting, Class.new(Email)).class_eval do
        attr_accessor :name
      end
    end
    make_template TestMailer, :greeting, "Hi, <%= name %>!"
  end

  before do
    @rat = EmailRat.new('fred@example.com')
  end

  describe "initial state" do
    it "should have the given address" do
      @rat.address.should == 'fred@example.com'
    end

    it "should have no current email" do
      @rat.email.should be_nil
    end
  end

  describe "#receive" do
    def send_greeting_to(name)
      email = TestMailer::Greeting.new(:name => name.capitalize)
      email.to = "#{name}@example.com"
      email.deliver.should be_true
    end

    describe "the first time it is called" do
      before do
        @rat = EmailRat.new('fred@example.com')
      end

      describe "when an email was sent to is address" do
        before do
          send_greeting_to 'fred'
        end

        it "should return true and make the first email for this address current" do
          @rat.receive.should be_true
          @rat.email.body.should == 'Hi, Fred!'
        end
      end

      describe "when no emails have been sent to the address" do
        it "should return false and set the current email to nil" do
          @rat.receive.should be_false
          @rat.email.should be_nil
        end
      end
    end

    describe "when it has already called it before" do
      before do
        @rat = EmailRat.new('fred@example.com')
        send_greeting_to 'fred'
        send_greeting_to 'wilma'
        @rat.receive.should be_true
      end

      describe "when there is another email for this user" do
        before do
          send_greeting_to 'fred'
        end

        it "should return true and make the next email for this address current" do
          @rat.receive.should be_true
          @rat.email.body.should == 'Hi, Fred!'
        end
      end

      describe "when there are no more emails for this user" do
        it "should return false and set the current email to nil" do
          @rat.receive.should be_false
          @rat.email.should be_nil
        end
      end
    end
  end
end
