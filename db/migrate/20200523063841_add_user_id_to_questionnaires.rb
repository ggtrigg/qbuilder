class AddUserIdToQuestionnaires < ActiveRecord::Migration[6.0]
  def change
    add_reference :questionnaires, :user, null: false, foreign_key: true
  end
end
