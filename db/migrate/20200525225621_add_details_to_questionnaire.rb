class AddDetailsToQuestionnaire < ActiveRecord::Migration[6.0]
  def change
    add_column :questionnaires, :r_address, :boolean
    add_column :questionnaires, :r_email, :boolean
    add_column :questionnaires, :r_phone, :boolean
    add_column :questionnaires, :r_age, :boolean
    add_column :questionnaires, :r_sex, :boolean
  end
end
