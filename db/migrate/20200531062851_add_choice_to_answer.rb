class AddChoiceToAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :choice, :string
  end
end
