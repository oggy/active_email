class TestMailer < EasyMailer::Base
  email :greeting do
    attr_accessor :name
    validates_presence_of :name

    attr_accessible :recipients
  end

  # read templates from spec dir
  self.template_root = "#{PLUGIN_ROOT}/spec/views"
end
