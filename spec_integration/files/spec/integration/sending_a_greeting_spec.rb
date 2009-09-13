require 'spec/spec_helper'

describe "Sending a greeting", :type => :integration do
  before do
    @fred = ActiveEmail::EmailRat.new('fred@example.com')
    visit '/greetings/new'
  end

  it "should send a greeting if the name is given" do
    fill_in :name, :with => 'Fred'
    click_button 'Send email!'
    @fred.should have_received_email
    @fred.email.body.should == "Hi, Fred!"
    response.should contain('Email sent!')
  end

  it "should not send a greeting the name is missing" do
    click_button 'Send email!'
    @fred.should_not have_received_email
    response.should contain('Oh noes!')
  end
end
