class AddCompositeIndexToResponses < ActiveRecord::Migration[8.1]
  def change
    add_index :responses, [ :questionnaire_id, :created_at ], name: :index_responses_on_questionnaire_id_and_created_at
  end
end
