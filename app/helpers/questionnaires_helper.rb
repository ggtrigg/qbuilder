module QuestionnairesHelper
  def score_range_s(question)
    "(#{question.score_range.first} to #{question.score_range.last})"
  end
end
