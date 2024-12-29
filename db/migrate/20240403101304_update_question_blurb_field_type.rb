class UpdateQuestionBlurbFieldType < ActiveRecord::Migration[6.1]
  def up
    change_column :questions, :blurb, :text
  end

  def down
    change_column :questions, :blurb, :string
  end
end
