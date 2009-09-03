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
        class_eval <<-EOS, __FILE__, __LINE__
          def self.#{name}_email(attributes)
            define_email_class(:#{name}) if @@undefined_email_classes[:#{name}]
            #{email_class_name}.new(self, :#{name}, attributes)
          end

          def #{name}(email)
            @email = email
            recipients   email.to
            subject      email.subject if !email.subject.blank?
            from         email.from
            cc           email.cc
            bcc          email.bcc
            reply_to     email.reply_to
            sent_on      email.sent_on if !email.sent_on.blank?
            content_type email.content_type if !email.content_type.blank?
            headers      email.headers
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
