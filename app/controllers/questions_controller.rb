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

    render :js, template: 'questions/question'
  end

  # POST /questions
  # POST /questions.json
  def create
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @question = @questionnaire.questions.new(question_params)
    @response_count = @questionnaire.responses.count

    respond_to do |format|
      if @question.save
        format.html { redirect_to @questionnaire, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @questionnaire }
        format.js { flash.now[:notice] = 'Question was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
        format.js { flash.now[:alert] = @question.errors.map do |e|
          [e.attribute == :blurb ? 'Question' : e.attribute.to_s.capitalize,
          e.message].join(' ')
        end.join(', ') }
      end
    end
  end

  def show
  end

  def edit
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @question = @questionnaire.questions.find(params[:id])
    @response_count = @questionnaire.responses.count

    render :js, template: 'questions/question'
  end

  def update
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
    @question = @questionnaire.questions.find(params[:id])
    @response_count = @questionnaire.responses.count

    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @questionnaire, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :created, location: @questionnaire }
        format.js { flash.now[:notice] = 'Question was successfully updated.' }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
        format.js { flash.now[:alert] = @question.errors.map do |e|
          [e.attribute == :blurb ? 'Question' : e.attribute.to_s.capitalize,
          e.message].join(' ')
        end.join(', ') }
      end
    end
  end


  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @questionnaire = @question.questionnaire
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questionnaire_url(@questionnaire), notice: 'Question was successfully deleted.' }
      format.json { head :no_content }
      format.js  { flash.now[:notice] = 'Question was successfully deleted.' }
    end
  end

  def sort
    params[:question].each_with_index do |id, index|
      Question.where(id: id).update_all(position: index + 1)
    end

    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:blurb, :answer_type, :choices, :score_range)
    end
end
