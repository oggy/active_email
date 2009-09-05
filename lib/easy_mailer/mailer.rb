module EasyMailer
  class Mailer < ActionMailer::Base
    def easy_email(email)
      @email = email
      template     email.class.name.underscore
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

    helper Helper

    # Make ActionMailer ignore the mailer name when searching for
    # templates.
    self.mailer_name = ''
  end
end
