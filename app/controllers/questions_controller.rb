# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show edit update destroy]

  # POST /questions
  # POST /questions.json
  def create
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @question = @questionnaire.questions.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to @questionnaire, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @questionnaire }
      else
        format.html { render :new }
        format.json { render json: @questionnaire.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @questionnaire = @question.questionnaire
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questionnaire_url(@questionnaire), notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:blurb, :answer_type, :choices)
    end
end
