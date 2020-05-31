class AddChoicesToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :choices, :string
  end
end
