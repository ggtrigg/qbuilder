class RemoveColumnsFromResponse < ActiveRecord::Migration[8.0]
  def change
    %i[encrypted_name encrypted_address encrypted_email encrypted_phone encrypted_age encrypted_sex
      encrypted_name_iv encrypted_address_iv encrypted_email_iv encrypted_phone_iv encrypted_age_iv encrypted_sex_iv
      name_tmp address_tmp email_tmp phone_tmp age_tmp sex_tmp].each do |column|
      remove_column :responses, column, :string
    end
  end
end
