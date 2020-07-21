class QuestionnairesController < ApplicationController
  before_action :set_questionnaire, only: [:show, :edit, :update, :destroy, :thankyou]
  before_action :authenticate_user!, except: [:thankyou, :landing]

  # GET /questionnaires
  # GET /questionnaires.json
  def index
    @questionnaires = current_user.questionnaires.all
  end

  # GET /questionnaires/1
  # GET /questionnaires/1.json
  def show
  end

  # GET /questionnaires/new
  def new
    @questionnaire = current_user.questionnaires.new
  end

  # GET /questionnaires/1/edit
  def edit
  end

  # POST /questionnaires
  # POST /questionnaires.json
  def create
    @questionnaire = current_user.questionnaires.new(questionnaire_params)

    respond_to do |format|
      if @questionnaire.save
        format.html { redirect_to @questionnaire, notice: 'Questionnaire was successfully created.' }
        format.json { render :show, status: :created, location: @questionnaire }
      else
        format.html { render :new }
        format.json { render json: @questionnaire.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questionnaires/1
  # PATCH/PUT /questionnaires/1.json
  def update
    respond_to do |format|
      if @questionnaire.update(questionnaire_params)
        format.html { redirect_to @questionnaire, notice: 'Questionnaire was successfully updated.' }
        format.json { render :show, status: :ok, location: @questionnaire }
      else
        format.html { render :edit }
        format.json { render json: @questionnaire.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questionnaires/1
  # DELETE /questionnaires/1.json
  def destroy
    @questionnaire.destroy
    respond_to do |format|
      format.html { redirect_to questionnaires_url, notice: 'Questionnaire was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def thankyou
  end

  def landing
    redirect_to questionnaires_path if user_signed_in?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_questionnaire
      begin
        @questionnaire = Questionnaire.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        @questionnaire = Questionnaire.new
      end
    end

    # Only allow a list of trusted parameters through.
    def questionnaire_params
      params.require(:questionnaire).permit(:title, :description, :submit_message,
        :user_id, *Questionnaire::R_ATTRIBUTES.map {|r| r.to_sym},
        questions_attributes: [:blurb, :answer_type, :choices, :score_range])
    end
end
