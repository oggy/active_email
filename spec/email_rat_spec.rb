require 'spec_helper'

describe EmailRat do
  before do
    temporary_email_class :Greeting do
      attr_accessor :name
    end
    make_template "greeting.erb", "Hi, <%= name %>!"
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
    def send_greeting_to(name, options={})
      email = Greeting.new(:name => name.capitalize)
      email.to = "#{name}@example.com"
      options.each do |name, value|
        email.send("#{name}=", value)
      end
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

      describe "when an email has been sent directly to this user" do
        before do
          send_greeting_to 'fred'
        end

        it "should return true and make the next email for this address current" do
          @rat.receive.should be_true
          @rat.email.body.should == 'Hi, Fred!'
        end
      end

      describe "when the user has been CC'd" do
        before do
          send_greeting_to 'wilma', :cc => 'fred@example.com'
        end

        it "should return true" do
          @rat.receive.should be_true
        end

        it "should indicate that the user was CCd" do
          @rat.receive
          @rat.ccd?.should be_true
        end

        it "should indicate that the user was not BCCd" do
          @rat.receive
          @rat.bccd?.should be_false
        end
      end

      describe "when the user has been BCC'd" do
        before do
          send_greeting_to 'wilma', :bcc => 'fred@example.com'
        end

        it "should return true" do
          @rat.receive.should be_true
        end

        it "should indicate that the user was BCCd" do
          @rat.receive
          @rat.bccd?.should be_true
        end

        it "should indicate that the user was not CCd" do
          @rat.receive
          @rat.ccd?.should be_false
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
