module QuestionnairesHelper
  def score_range_s(question)
    "(#{question.score_range.first} to #{question.score_range.last})"
  end

  def action_url(question)
    case action_name
    when 'new'
      questionnaire_questions_path(question.questionnaire)
    when 'edit'
      questionnaire_question_path(question.questionnaire, question)
    end
  end
end
