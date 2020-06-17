class AddScoreRangeToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :score_range, :string
  end
end
