class Questionnaire < ApplicationRecord
    has_many :questions, dependent: :destroy
    has_rich_text :description

    accepts_nested_attributes_for :questions, allow_destroy: true

    include Hashid::Rails
end
