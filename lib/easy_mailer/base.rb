module EasyMailer
  class Base < ActionMailer::Base
    class Email
      attr_accessor :recipients
      alias to recipients
      alias to= recipients=

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

    @@undefined_email_classes = {}
    class << self
      #
      # Define an email, which will be validated by an email model.
      #
      def email(name, &block)
        email_class_name = "#{name.to_s.camelize}Email"
        @@undefined_email_classes[name] = [email_class_name, block]
        class_eval <<-EOS
          def self.#{name}_email(attributes)
            define_email_class(:#{name}) if @@undefined_email_classes[:#{name}]
            #{email_class_name}.new(self, :#{name}, attributes)
          end

          def #{name}(email)
            @email = email
            recipients email.recipients
          end
        EOS
      end

      def define_email_class(name)
        name, definition = @@undefined_email_classes.delete(name)
        klass = const_set(name, Class.new(Email))
        klass.class_eval(&definition)
      end
    end

    helper EasyMailer::Helper
  end
end
