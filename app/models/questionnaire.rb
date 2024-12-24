# frozen_string_literal: true

class Questionnaire < ApplicationRecord
  belongs_to :user
  has_many :responses, dependent: :destroy
  has_many :questions, -> { order(position: :asc) }, dependent: :destroy
  has_rich_text :description
  has_rich_text :submit_message

  accepts_nested_attributes_for :questions, allow_destroy: true

  include Hashid::Rails

  validates :title, presence: true
  validates :redirect_url, url: { allow_blank: true }

  R_ATTRIBUTES = %w(r_address r_email r_phone r_age r_sex)

  def redirect_delay_secs
    read_attribute(:redirect_delay_secs) || 15
  end

  def r_attributes
    attributes.slice(*R_ATTRIBUTES).select {|k, v| v.present?}.keys.map {|v| v.delete_prefix 'r_'}.prepend 'name'
  end

  def editable?
    responses.none?
  end
end
