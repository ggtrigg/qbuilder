class AddDefaultAndNotNullToUsersAdmin < ActiveRecord::Migration[8.1]
  def change
    change_column_default :users, :admin, false
    # Update existing NULL values to false
    User.where(admin: nil).update_all(admin: false)
    change_column_null :users, :admin, false
  end
end
