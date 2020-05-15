class Response < ApplicationRecord
  belongs_to :questionnaire
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers

  include Hashid::Rails
end
