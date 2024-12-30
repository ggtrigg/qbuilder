# frozen_string_literal: true

class ResponsesController < ApplicationController
  before_action :set_response, only: %i[show destroy]
  before_action :set_questionnaire, only: %i[index new create show destroy]
  before_action :authenticate_user!, only: %i[index show destroy]

  # GET /responses
  # GET /responses.json
  def index
    @responses = @questionnaire.responses.all
    respond_to do |format|
      format.html
      format.csv { send_data @responses.to_csv, filename: "responses-#{Date.today}.csv" }
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
    @response = @questionnaire.responses.build(response_params.reject { |k, v| v.empty? })

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
        format.html { render :new, status: :unprocessable_entity }
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
      unless ([ "new", "create" ].include? action_name) or (@questionnaire.user == current_user) or current_user.admin?
        redirect_to questionnaires_path, alert: "Questionnaire not available."
      end
  end

    # Only allow a list of trusted parameters through.
    def response_params
      params.require(:response).permit(:name, :address, :phone, :email, :age, :sex, answers_attributes: %i[ id question_id yes_no atext choice ] << { choice: [] })
    end
end
