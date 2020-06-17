class Question < ApplicationRecord
  belongs_to :questionnaire
  acts_as_list scope: :questionnaire

  enum answer_type: [:true_false, :yes_no, :single_line, :multi_line, :multiple_choice_single, :multiple_choice_any, :score]

  validates :blurb, presence: true

  def choices
    read_attribute(:choices).split /\R/ if read_attribute(:choices).present?
  end

  def score_range
    read_attribute(:score_range).present? ? Range.new(*(read_attribute(:score_range).split(';')[0,2])) : 1..10
  end

  def inlineable?
    max_words = choices.map {|c| c.split.count }.max
    average_length = choices.map {|c| c.length }.sum / choices.count

    (max_words < 4) && (average_length < 30)
  end
end
