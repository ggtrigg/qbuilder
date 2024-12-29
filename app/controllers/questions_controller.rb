# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show edit update destroy]

  def new
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    last = @questionnaire.questions.last
    @question = @questionnaire.questions.new()

    if last.present?
      @question.answer_type = last.answer_type
      @question.score_range = last.score_range
    end

    render
  end

  # POST /questions
  # POST /questions.json
  def create
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @question = @questionnaire.questions.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { render partial: "questionnaires/questions", locals: { questionnaire: @questionnaire } }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @question = @questionnaire.questions.find(params[:id])
  end

  def update
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @question = @questionnaire.questions.find(params[:id])

    respond_to do |format|
      if @question.update(question_params)
        format.html { render partial: "questionnaires/questions", locals: { questionnaire: @questionnaire } }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @questionnaire = @question.questionnaire
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questionnaire_url(@questionnaire) }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@question) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:blurb, :answer_type, :choices, :score_range, :position)
    end
end
