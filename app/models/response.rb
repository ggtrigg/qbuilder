class Response < ApplicationRecord
  belongs_to :questionnaire
  has_many :answers, dependent: :destroy, index_errors: true
  accepts_nested_attributes_for :answers, reject_if: :all_blank

  include Hashid::Rails
  include EmailAddressUtil

  attribute :sexes, :string
  enum :sexes, {male: 0, female: 1, other: 2}

  validates :name, presence: true
  validates :address, presence: true, if: -> { questionnaire.r_address }
  validates :phone, presence: true, if: -> { questionnaire.r_phone }
  validates :age, presence: true, if: -> { questionnaire.r_age }
  validates :sex, presence: true, if: -> { questionnaire.r_sex }
  validates :email, presence: true, if: -> { questionnaire.r_email }
  # validates_each :email, if: -> { questionnaire.r_email } do |record, attr, value|
  #   record.errors.add(attr, 'address invalid') unless record.email_valid?
  # end
  validates_associated :answers

  encrypts :name
  encrypts :address
  encrypts :email
  encrypts :phone
  encrypts :age
  encrypts :sex
  
  def email_valid?
    valid_address?(email)
  end
end
