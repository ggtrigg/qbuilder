class Answer < ApplicationRecord
  belongs_to :response
  belongs_to :question
  
  validates :atext, presence: {message: "can't be blank"}, if: -> { %w(single_line multi_line).include? question.answer_type }
  validates :yes_no, presence: {message: "option isn't selected"}, if: -> { %w(yes_no true_false).include? question.answer_type }
  validates :choice, presence: {message: 'not selected'}, if: -> { %w(multiple_choice_any multiple_choice_single score).include? question.answer_type }

  def value(multiple_choice_separator = ', ')
    case question.answer_type.to_sym
    when :single_line, :multi_line
      atext
    when :yes_no
      yes_no ? 'Yes' : 'No'
    when :true_false
      yes_no.to_s.humanize
    when :multiple_choice_single
      question.choices[choice.to_i]
    when :multiple_choice_any
      if choice.present?
        question.choices.values_at(*(JSON.parse(choice).map {|n| n.to_i})).join(multiple_choice_separator)
      else
        '(No choices selected)'
      end
    when :score
      choice.to_i
    end
  end
end
