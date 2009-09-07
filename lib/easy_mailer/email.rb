module EasyMailer
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

    def initialize(attributes=nil)
      super
      unless attributes.nil?
        attributes.each do |name, value|
          send("#{name}=", value)
        end
      end
    end

    #
    # Deliver the email using ActionMailer.
    #
    def deliver
      if valid?
        run_callbacks :before_delivery
        Mailer.deliver_easy_email(self)
        run_callbacks :after_delivery
        true
      else
        false
      end
    end
  end
end
