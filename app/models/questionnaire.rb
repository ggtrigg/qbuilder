# frozen_string_literal: true

class Questionnaire < ApplicationRecord
  belongs_to :user
  has_many :responses, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_rich_text :description

  accepts_nested_attributes_for :questions, allow_destroy: true

  include Hashid::Rails

  validates :title, presence: true

  R_ATTRIBUTES = %w(r_address r_email r_phone r_age r_sex)
end
