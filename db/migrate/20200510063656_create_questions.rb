class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :blurb
      t.integer :answer_type
      t.references :questionnaire, null: false, foreign_key: true

      t.timestamps
    end
  end
end
