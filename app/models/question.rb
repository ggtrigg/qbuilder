class Question < ApplicationRecord
  belongs_to :questionnaire
  acts_as_list scope: :questionnaire

  attribute :answer_type, :integer
  enum answer_type: [:true_false, :yes_no, :single_line, :multi_line, :multiple_choice_single, :multiple_choice_any, :score]

  validates :blurb, presence: true

  def choices
    read_attribute(:choices).split /\R/ if read_attribute(:choices).present?
  end

  def to_range
    if score_range.present? && score_range =~ /\A(\d+)(;|\.\.|-)(\d+)\Z/
      Range.new($1, $3)
    else
      1..10
    end
  end

  def inlineable?
    max_words = choices.map {|c| c.split.count }.max
    average_length = choices.map {|c| c.length }.sum / choices.count

    (max_words < 4) && (average_length < 30)
  end
end
