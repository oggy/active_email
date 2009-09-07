module ApplicationHelper
  def flash_messages
    [:notice, :error].map do |key|
      if flash[key]
        "<div class='flash #{key}'>#{h flash[key]}</div>"
      end
    end.compact.join
  end
end
