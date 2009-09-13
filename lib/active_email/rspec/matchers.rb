module ActiveEmail
  module RSpec
    module Matchers
      #
      # Matches if an inbox (represented by an EmailRat) receives an
      # email.
      #
      #     support = EmailRat.new('support@patch.com')
      #     support.should have_received_email
      #
      # Once #have_received_email is called, email data may be accessed
      # through EmailRat#email.
      #
      #     support.email.subject.should contain('HELP!')
      #     support.email.body.should contain('Send me money!')
      #
      def have_received_email
        HaveReceivedEmail.new
      end

      class HaveReceivedEmail
        def matches?(email_rat)
          @email_rat = email_rat
          @email_rat.receive
        end

        def failure_message_for_should
          "#{@email_rat.address} should have received an email"
        end

        def failure_message_for_should_not
          "#{@email_rat.address} should not have received an email"
        end
      end
    end
  end
end
