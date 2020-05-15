# frozen_string_literal: true

class ResponsesController < ApplicationController
  before_action :set_response, only: %i[show edit update destroy]
  before_action :set_questionnaire, only: %i[index new create show destroy]

  # GET /responses
  # GET /responses.json
  def index
    @responses = @questionnaire.responses.all
  end

  # GET /responses/1
  # GET /responses/1.json
  def show; end

  # GET /responses/new
  def new
    @response = @questionnaire.responses.new
    @questionnaire.questions.all.each do |question|
      @response.answers.build question_id: question.id
    end
  end

  # GET /responses/1/edit
  def edit;
  end

  # POST /responses
  # POST /responses.json
  def create
    @response = @questionnaire.responses.build(response_params)

    respond_to do |format|
      if @response.save
        format.html { redirect_to questionnaire_response_path(@questionnaire, @response), notice: 'Thank you for your response.' }
        format.json { render :show, status: :created, location: @response }
      else
        format.html { render :new }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responses/1
  # PATCH/PUT /responses/1.json
  def update
    respond_to do |format|
      if @response.update(response_params)
        format.html { redirect_to @response, notice: 'Response was successfully updated.' }
        format.json { render :show, status: :ok, location: @response }
      else
        format.html { render :edit }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /responses/1
  # DELETE /responses/1.json
  def destroy
    @response.destroy
    respond_to do |format|
      format.html { redirect_to questionnaire_responses_url(@questionnaire), notice: 'Response was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_response
      @response = Response.find(params[:id])
    end

    def set_questionnaire
      @questionnaire = Questionnaire.find(params[:questionnaire_id])
    end

    # Only allow a list of trusted parameters through.
    def response_params
      params.require(:response).permit(:name, answers_attributes: %i[id question_id yes_no atext])
    end
end
