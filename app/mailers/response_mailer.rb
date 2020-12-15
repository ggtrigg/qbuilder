class ResponseMailer < ApplicationMailer
  helper ResponsesHelper
  
  def send_response
    @response = @params[:response]
    @user = @response.questionnaire.user
    if @response.email
      mail(to: @user.email, from: @response.email, subject: "Questionnaire response submitted: #{@response.name}")
    else
      mail(to: @user.email, subject: "Questionnaire response submitted: #{@response.name}")
    end
  end
end
