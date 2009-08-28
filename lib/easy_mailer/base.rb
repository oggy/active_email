module EasyMailer
  class Base < ActionMailer::Base
    class Email
      include Validatable

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

    #
    # Define an email, which will be validated by an email model.
    #
    def self.email(name, &block)
      email_class_name = "#{name.to_s.camelize}Email"
      email_class = const_set(email_class_name, Class.new(Email))
      email_class.class_eval(&block)
      class_eval <<-EOS
        def self.#{name}_email(attributes)
          #{email_class_name}.new(self, :#{name}, attributes)
        end

        def #{name}(email)
          @email = email
        end
      EOS
    end
  end
end
