class Greeting < EasyMailer::Email
  attribute :name, :string
  validates_presence_of :name

  before_delivery :set_email_fields

  def set_email_fields
    self.to = "#{name.downcase}@example.com"
    self.subject = 'Greetings!'
  end
end
