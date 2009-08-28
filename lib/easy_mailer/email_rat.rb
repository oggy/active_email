module EasyMailer
  #
  # Represents a user's inbox in acceptance tests.
  #
  # See EmailRat::Matchers#have_received_email for use with RSpec.
  #
  class EmailRat
    #
    # Create an EmailRat for the given address.
    #
    def initialize(address)
      @address = address
      @index = -1
    end

    attr_reader :address

    #
    # Put the next message in #current, or nil if none is found.  Return
    # true if another message is found, false otherwise.
    #
    def receive
      begin
        advance
      end until email.nil? || Array(email.to).include?(address)
      !!email
    end

    #
    # The current email.
    #
    def email
      @index < 0 ? nil : deliveries[@index]
    end

    private

    def deliveries
      ActionMailer::Base.deliveries
    end

    def advance
      @index += 1
    end
  end
end
