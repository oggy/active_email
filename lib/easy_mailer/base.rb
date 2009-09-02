module EasyMailer
  class Base < ActionMailer::Base
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

require 'easy_mailer/base/email'
