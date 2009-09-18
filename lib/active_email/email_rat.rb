module ActiveEmail
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
      end until email.nil? || @received
      !!email
    end

    #
    # The current email.
    #
    def email
      @index < 0 ? nil : deliveries[@index]
    end

    #
    # Return true if we were CCd on the last received email.
    #
    def ccd?
      @ccd
    end

    #
    # Return true if we were BCCd on the last received email.
    #
    def bccd?
      @bccd
    end

    private

    def deliveries
      ActionMailer::Base.deliveries
    end

    def advance
      @index += 1
      if email
        @ccd = Array(email.cc).include?(address)
        @bccd = Array(email.bcc).include?(address)
        @received = Array(email.to).include?(address) || @ccd || @bccd
      end
    end
  end
end
