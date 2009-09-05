module Helpers
  #
  # Define a temporary mailer class with #temporary_mailer.
  #
  # Make templates with #make_template.
  #
  module TemporaryMailer
    def self.included(base)
      base.before{initialize_temporary_mailers}
      base.after{finalize_temporary_mailers}
    end

    def temporary_mailer(name, superclass=Mailer, &definition)
      mailer_class = Class.new(superclass)
      Object.const_set(name, mailer_class)
      mailer_class.class_eval(&definition)
      mailer_class.template_root = temporary_directory
      @temporary_mailers << name
    end

    def make_template(mailer, name, content)
      file_name = "#{mailer.template_root}/#{mailer.name.underscore}/#{name}.erb"
      FileUtils.mkdir_p(File.dirname(file_name))
      open(file_name, 'w'){|f| f.write content}
    end

    private  # -------------------------------------------------------

    def initialize_temporary_mailers
      @temporary_mailers = []
    end

    def finalize_temporary_mailers
      @temporary_mailers.each{|name| Object.send(:remove_const, name)}
    end
  end
end
