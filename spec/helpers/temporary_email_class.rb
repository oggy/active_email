module Helpers
  module TemporaryEmailClass
    def self.included(base)
      base.before{initialize_temporary_email_class}
      base.after{finalize_temporary_email_class}
    end

    #
    # Create a temporary Email class that will be removed after each
    # test.
    #
    def temporary_email_class(name, superclass=Email, &definition)
      klass = Class.new(superclass)
      Object.const_set(name, klass)
      klass.class_eval(&definition) if definition
      @temporary_email_classes << name
    end

    #
    # Create a template at the given path in the templates directory.
    #
    def make_template(path, content)
      file_name = "#{temporary_directory}/templates/#{path}"
      FileUtils.mkdir_p(File.dirname(file_name))
      open(file_name, 'w'){|f| f.write content}
    end

    private  # -------------------------------------------------------

    def initialize_temporary_email_class
      Mailer.template_root = "#{temporary_directory}/templates"
      @temporary_email_classes = []
    end

    def finalize_temporary_email_class
      @temporary_email_classes.each{|name| Object.send(:remove_const, name)}
    end
  end
end
