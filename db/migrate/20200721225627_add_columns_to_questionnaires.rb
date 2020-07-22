class AddColumnsToQuestionnaires < ActiveRecord::Migration[6.0]
  def change
    add_column :questionnaires, :redirect_url, :string
    add_column :questionnaires, :redirect_delay_secs, :integer
  end
end
