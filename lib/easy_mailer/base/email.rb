module EasyMailer
  class Base
    class Email < ActiveRecordBaseWithoutTable
      define_callbacks :before_delivery, :after_delivery

      [:to, :from, :cc, :bcc, :reply_to].each do |name|
        class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            @#{name} ||= []
          end
          def #{name}=(value)
            @#{name} = Array(value)
          end
        EOS
      end

      attr_accessor :subject
      attr_accessor :sent_on
      attr_accessor :content_type

      def headers
        @headers ||= {}
      end
      attr_writer :headers

      def initialize(mailer, attributes={})
        @mailer = mailer
        attributes.each do |name, value|
          send("#{name}=", value)
        end
      end

      #
      # Deliver the email using ActionMailer.
      #
      def deliver
        if valid?
          run_callbacks :before_delivery
          @mailer.deliver_easy_email(self)
          run_callbacks :after_delivery
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
