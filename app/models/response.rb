class Response < ApplicationRecord
  belongs_to :questionnaire
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers

  include Hashid::Rails

  enum sexes: {male: 'Male', female: 'Female', other: 'Other'}

  validates :name, presence: true

  attr_encrypted_options.merge!(allow_empty_value: true)
  attr_encrypted :name, key: Rails.application.credentials.response[:name_key]
  attr_encrypted :address, key: Rails.application.credentials.response[:address_key]
  attr_encrypted :email, key: Rails.application.credentials.response[:email_key]
  attr_encrypted :phone, key: Rails.application.credentials.response[:phone_key]
  attr_encrypted :age, key: Rails.application.credentials.response[:age_key]
  attr_encrypted :sex, key: Rails.application.credentials.response[:sex_key]

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
