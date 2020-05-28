class ChangeColumnsOnResponse < ActiveRecord::Migration[6.0]
  def change
    rename_column :responses, :name, :encrypted_name
    add_column :responses, :encrypted_name_iv, :string
  end
end
