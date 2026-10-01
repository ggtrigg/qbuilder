class CreateAdminImpersonations < ActiveRecord::Migration[8.1]
  def change
    create_table :admin_impersonations do |t|
      t.references :admin, null: false, foreign_key: { to_table: :users }
      t.references :target_user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
