require 'spec_helper'

describe Base::Email do
  describe "validations" do
    before do
      temporary_mailer :TestMailer do
        const_set(:Greeting, Class.new(Base::Email)).class_eval do
          attr_accessible :name
          validates_presence_of :name
        end
      end
    end

    it "should work like ActiveRecord" do
      model = TestMailer.new_email(:greeting, :name => '')
      model.should_not be_valid
      model.errors.on(:name).should_not be_nil
    end

    it "should prevent the email being sent if the email does not validate" do
      model = TestMailer.new_email(:greeting, :name => '')
      model.deliver.should be_false
      model.errors.on(:name).should_not be_nil
      ActionMailer::Base.deliveries.should be_empty
    end
  end

  describe "#before_delivery" do
    before do
      temporary_mailer :TestMailer do
        const_set(:Greeting, Class.new(Base::Email)).class_eval do
          attr_accessor :num_deliveries
          before_delivery :set_num_deliveries
          def set_num_deliveries
            self.num_deliveries = ActionMailer::Base.deliveries.size
          end
        end
      end
      make_template TestMailer, :greeting, ''
      @email = TestMailer.new_email(:greeting, {})
    end

    it "should fire just before calling #deliver" do
      @email.deliver.should be_true
      @email.num_deliveries.should == 0
    end

    it "should not be called if validation fails" do
      @email.stubs(:valid?).returns(false)
      @email.deliver.should be_false
      @email.num_deliveries.should be_nil
    end
  end

  describe "#after_delivery" do
    before do
      temporary_mailer :TestMailer do
        const_set(:Greeting, Class.new(Base::Email)).class_eval do
          attr_accessor :num_deliveries
          after_delivery :set_num_deliveries
          def set_num_deliveries
            self.num_deliveries = ActionMailer::Base.deliveries.size
          end
        end
      end
      make_template TestMailer, :greeting, ''
      @email = TestMailer.new_email(:greeting, {})
    end

    it "should fire just after calling #deliver" do
      @email.deliver.should be_true
      @email.num_deliveries.should == 1
    end

    it "should not be called if validation fails" do
      @email.stubs(:valid?).returns(false)
      @email.deliver.should be_false
      @email.num_deliveries.should be_nil
    end
  end

  describe "email fields" do
    before do
      temporary_mailer :TestMailer do
        const_set(:Greeting, Class.new(Base::Email))
      end
      make_template TestMailer, :greeting, 'hi'
      @email = TestMailer.new_email(:greeting, {})
    end

    def delivery
      ActionMailer::Base.deliveries.first
    end

    it "should have a default of [] for #to" do
      @email.to.should == []
    end

    it "should have a default of nil for #subject" do
      @email.subject.should be_nil
    end

    it "should have a default of [] for #from" do
      @email.from.should == []
    end

    it "should have a default of [] for #cc" do
      @email.cc.should == []
    end

    it "should have a default of [] for #bcc" do
      @email.bcc.should == []
    end

    it "should have a default of [] for #reply_to" do
      @email.reply_to.should == []
    end

    it "should have a default of nil for #sent_on" do
      @email.sent_on.should be_nil
    end

    it "should have a default of nil for #content_type" do
      @email.content_type.should be_nil
    end

    it "should have a default of {} for #headers" do
      @email.headers.should == {}
    end

    it "should not make any of the email fields accessible by default"
  end
end
