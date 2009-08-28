module EasyMailer
  module Helper
    #
    # Delegate methods to the email automatically.
    #
    def method_missing(name, *args, &block)
      if @email.respond_to?(name)
        @email.__send__(name, *args, &block)
      else
        super
      end
    end
  end
end
