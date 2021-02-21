class Response < ApplicationRecord
  belongs_to :questionnaire
  has_many :answers, dependent: :destroy, index_errors: true
  accepts_nested_attributes_for :answers, reject_if: :all_blank

  include Hashid::Rails
  include EmailAddressUtil

  enum sexes: {male: 'Male', female: 'Female', other: 'Other'}

  validates :name, presence: true
  validates :address, presence: true, if: -> { questionnaire.r_address }
  validates :phone, presence: true, if: -> { questionnaire.r_phone }
  validates :age, presence: true, if: -> { questionnaire.r_age }
  validates :sex, presence: true, if: -> { questionnaire.r_sex }
  validates_each :email, if: -> { questionnaire.r_email } do |record, attr, value|
    record.errors.add(attr, 'address invalid') unless record.email_valid?
  end
  validates_associated :answers

  attr_encrypted_options.merge!(allow_empty_value: true)
  attr_encrypted :name, key: Rails.application.credentials.response[:name_key]
  attr_encrypted :address, key: Rails.application.credentials.response[:address_key]
  attr_encrypted :email, key: Rails.application.credentials.response[:email_key]
  attr_encrypted :phone, key: Rails.application.credentials.response[:phone_key]
  attr_encrypted :age, key: Rails.application.credentials.response[:age_key]
  attr_encrypted :sex, key: Rails.application.credentials.response[:sex_key]
  
  def email_valid?
    valid_address?(email)
  end

  def self.to_csv
    require 'csv'

    CSV.generate(headers: true) do |csv|
      questionnaire = first.questionnaire
      csv << questionnaire.r_attributes + questionnaire.questions.map {|q| q.blurb }
      
      all.each do |response|
        csv << questionnaire.r_attributes.map{ |attr| response.send(attr) } + response.answers.map {|a| a.value '|' }
      end
    end
  end
end
