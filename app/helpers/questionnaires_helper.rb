module QuestionnairesHelper
  def score_range_s(question)
    "(#{question.to_range.first} to #{question.to_range.last})"
  end

  def action_url(question)
    case action_name
    when 'new'
      questionnaire_questions_path(question.questionnaire)
    when 'edit'
      questionnaire_question_path(question.questionnaire, question)
    end
  end

  def responses_count_str(questionnaire)
    count = questionnaire.responses.count
    text = 'response'.pluralize(count)
    "#{count} #{text}"
  end
end
