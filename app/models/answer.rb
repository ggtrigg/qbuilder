class Answer < ApplicationRecord
  belongs_to :response
  belongs_to :question

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
