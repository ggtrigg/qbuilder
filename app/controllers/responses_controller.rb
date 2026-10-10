# frozen_string_literal: true

class ResponsesController < ApplicationController
  before_action :set_response, only: %i[show destroy]
  before_action :set_questionnaire, only: %i[index new create show destroy]
  before_action :authenticate_user!, only: %i[index show destroy]
  before_action :authorize_response, only: %i[index show destroy]

  if !Rails.env.test?
    invisible_captcha only: %i[create],
      honeypot: :surname,
      spinner: -> { "timestamp-#{SecureRandom.hex(8)}" }
  end

  # GET /responses
  # GET /responses.json
  def index
    @responses = @questionnaire.responses
    csv_headers = @questionnaire.questions.pluck(:blurb).prepend("Name")
    csv_responses = @responses.map { |response| response.answers.map(&:value).prepend(response.name) }
    respond_to do |format|
      format.html
      format.csv { send_data CsvBuilder.build(csv_responses, csv_headers), filename: "responses-#{Date.today}.csv" }
    end
  end

  # GET /responses/1
  # GET /responses/1.json
  def show
  end

  # GET /responses/new
  def new
    @response = @questionnaire.responses.new
    @questionnaire.questions.all.each do |question|
      @response.answers.build question_id: question.id
    end
  end

  # POST /responses
  # POST /responses.json
  def create
    @response = @questionnaire.responses.build(response_params)

    respond_to do |format|
      if @response.save
        if user_signed_in? && (@questionnaire.user == current_user)
          format.html { redirect_to questionnaire_response_path(@questionnaire, @response), notice: "Thank you for your response. (You responded to your own questionnaire!)" }
        else
          ResponseMailer.with(response: @response).send_response.deliver_now
          # format.html { redirect_to thankyou_path(@questionnaire) }
          format.html { render }
        end
      else
        format.html { render :new, status: :unprocessable_content }
      end
    end
  end

  # DELETE /responses/1
  # DELETE /responses/1.json
  def destroy
    @response.destroy
    respond_to do |format|
      format.html { redirect_to questionnaire_responses_url(@questionnaire) }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_response
      @response = Response.find(params[:id])
    end

    def set_questionnaire
      @questionnaire = Questionnaire.find(params[:questionnaire_id])
      # For actions requiring authentication (index, show, destroy):
      # - If user is not authenticated, let authenticate_user! handle redirect to login
      # - If user is authenticated, let authorize_response handle "Not authorized" for non-owners
      # For new and create (public forms), allow anyone
      if ([ "new", "create" ].include? action_name)
        # Public forms - allow anyone
      elsif user_signed_in?
        # Authenticated user - let authorize_response handle authorization
        # Don't redirect here
      else
        # Unauthenticated user on index/show/destroy - authenticate_user! will redirect to login
      end
    end

    # Only allow a list of trusted parameters through.
    def response_params
      params.require(:response).permit(:name, :address, :phone, :email, :age, :sex, answers_attributes: %i[ id question_id yes_no atext choice ] << { choice: [] })
    end

    def authorize_response
      if action_name == "index"
        redirect_to questionnaires_path, alert: "Not authorized." unless @questionnaire.user == current_user || current_user.admin?
      else
        redirect_to questionnaires_path, alert: "Not authorized." unless @response.questionnaire.user == current_user || current_user.admin?
      end
    end
end