class Question < ApplicationRecord
  belongs_to :questionnaire

  enum answer_type: [:true_false, :yes_no, :single_line, :multi_line]

  validates :blurb, presence: true
end
