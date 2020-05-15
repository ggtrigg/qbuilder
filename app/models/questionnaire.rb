# frozen_string_literal: true

class Questionnaire < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_rich_text :description

  accepts_nested_attributes_for :questions, allow_destroy: true

  include Hashid::Rails

  validates :title, presence: true
end
