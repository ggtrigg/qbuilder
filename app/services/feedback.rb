class Feedback
  def self.email
    Rails.application.config.x.feedback&.dig(:email) || "ggt@glenntrigg.net"
  end

  def self.questionnaire_title
    "Feedback form"
  end

  def self.questionnaire
    Questionnaire.joins(:user).where(title: questionnaire_title, user: { email: email }).first
  end

  QID = questionnaire&.hashid
  URL = QID.present? ? Rails.application.routes.url_helpers.new_response_path(QID) : nil
end
