require 'spec_helper'

describe ActiveEmail::RSpec::Matchers do
  HaveReceivedEmail = ActiveEmail::RSpec::Matchers::HaveReceivedEmail

  describe HaveReceivedEmail do
    before do
      @rat = EmailRat.new('fred@example.com')
    end

    describe "matches?" do
      it "should call EmailRat#receive exactly once" do
        @rat.expects(:receive).once
        matcher = HaveReceivedEmail.new
        matcher.matches?(@rat)
      end

      it "should match if EmailRat#receive returns true" do
        @rat.stubs(:receive).returns(true)
        matcher = HaveReceivedEmail.new
        matcher.matches?(@rat).should be_true
      end

      it "should not match if EmailRat#receive returns false" do
        @rat.stubs(:receive).returns(false)
        matcher = HaveReceivedEmail.new
        matcher.matches?(@rat).should be_false
      end
    end

    describe "#failure_message_for_should" do
      it "should look right" do
        @rat.stubs(:receive).returns(true)
        matcher = HaveReceivedEmail.new
        matcher.matches?(@rat)
        matcher.failure_message_for_should.should == "fred@example.com should have received an email"
      end
    end

    describe "#failure_message_for_should_not" do
      it "should look right" do
        @rat.stubs(:receive).returns(false)
        matcher = HaveReceivedEmail.new
        matcher.matches?(@rat)
        matcher.failure_message_for_should_not.should == "fred@example.com should not have received an email"
      end
    end
  end
end
