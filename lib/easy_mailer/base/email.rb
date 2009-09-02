module EasyMailer
  class Base
    class Email < ActiveRecordBaseWithoutTable
      attr_accessor :recipients
      alias to recipients
      alias to= recipients=

      def initialize(mailer, mail_name, attributes={})
        @mailer = mailer
        @mail_name = mail_name
        attributes.each do |name, value|
          send("#{name}=", value)
        end
      end

      #
      # Deliver the email using ActionMailer.
      #
      def deliver
        if valid?
          @mailer.send("deliver_#{@mail_name}", self)
          true
        else
          false
        end
      end

      #
      # Make the given attributes accessible via mass-assignment.  The
      # attributes are created if they don't exist yet.
      #
      def self.attr_accessible(*names)
        # TODO: implement whitelisting
        attr_accessor(*names)
      end
    end
  end
end
