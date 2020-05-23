class ResponseMailer < ApplicationMailer
  def send_response
    @response = @params[:response]
    @user = @response.questionnaire.user
    mail(to: @user.email, subject: "Questionnaire response submitted: #{@response.name}")
  end
end
