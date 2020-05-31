class Question < ApplicationRecord
  belongs_to :questionnaire

  enum answer_type: [:true_false, :yes_no, :single_line, :multi_line, :multiple_choice_single, :multiple_choice_any]

  validates :blurb, presence: true

  def choices
    read_attribute(:choices).split /\R/ if read_attribute(:choices).present?
  end

  def inlineable?
    max_words = choices.map {|c| c.split.count }.max
    average_length = choices.map {|c| c.length }.sum / choices.count

    (max_words < 4) && (average_length < 30)
  end
end
