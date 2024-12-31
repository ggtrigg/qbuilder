class QuestionnairesController < ApplicationController
  before_action :authenticate_user!, except: [ :thankyou, :landing ]
  before_action :set_questionnaire, only: [ :show, :edit, :update, :destroy, :thankyou ]

  # GET /questionnaires
  # GET /questionnaires.json
  def index
    @questionnaires = current_user.admin? ? Questionnaire.order(:user_id, :title).all : current_user.questionnaires.order(:title).all
  end

  def index_other
    return unless current_user.admin?
    user = User.find(params[:uid])
    @questionnaires = user.questionnaires.order(:title).all
    render :index
  end

  # GET /questionnaires/1
  # GET /questionnaires/1.json
  def show
    if params[:show_questions].present?
      render partial: "questionnaires/questions", locals: { questionnaire: @questionnaire }
    else
      render :show
    end
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
        format.html { redirect_to @questionnaire }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questionnaires/1
  # PATCH/PUT /questionnaires/1.json
  def update
    respond_to do |format|
      if @questionnaire.update(questionnaire_params)
        format.html { redirect_to @questionnaire }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questionnaires/1
  # DELETE /questionnaires/1.json
  def destroy
    @questionnaire.destroy
    respond_to do |format|
      format.html { redirect_to questionnaires_url, notice: "Questionnaire was successfully deleted." }
    end
  end

  def thankyou
    if @questionnaire.redirect_url.present? && @questionnaire.redirect_delay_secs.present?
      @do_redirect = true
    end
  end

  def landing
    respond_to do |format|
      format.html { redirect_to questionnaires_path if user_signed_in? }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_questionnaire
      begin
        @questionnaire = Questionnaire.find(params[:id])
        unless (action_name == "thankyou") or (@questionnaire.user == current_user) or current_user.admin?
          redirect_to questionnaires_path, alert: "Questionnaire not available."
        end
      rescue ActiveRecord::RecordNotFound
        @questionnaire = Questionnaire.new
      end
    end

    # Only allow a list of trusted parameters through.
    def questionnaire_params
      params.require(:questionnaire).permit(:title, :description, :submit_message, :redirect_url, :redirect_delay_secs,
        :user_id, *Questionnaire::R_ATTRIBUTES.map { |r| r.to_sym },
        questions_attributes: [ :blurb, :answer_type, :choices, :score_range ])
    end
end
