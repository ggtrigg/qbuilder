class AddColumnsToResponse < ActiveRecord::Migration[7.2]
  def change
    %i[name name_tmp address address_tmp email email_tmp phone phone_tmp age age_tmp sex sex_tmp].each do |column|
      add_column :responses, column, :string
    end
  end
end
