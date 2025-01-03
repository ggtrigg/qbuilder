class Feedback
  QID = Questionnaire.joins(:user).where(title: "Feedback form", user: { email: "ggt@glenntrigg.net" }).first&.hashid
  URL = QID.present? ? Rails.application.routes.url_helpers.new_response_path(QID) : nil
end
