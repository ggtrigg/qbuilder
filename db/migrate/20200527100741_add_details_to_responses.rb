class AddDetailsToResponses < ActiveRecord::Migration[6.0]
  def change
    add_column :responses, :encrypted_address, :string
    add_column :responses, :encrypted_address_iv, :string
    add_column :responses, :encrypted_email, :string
    add_column :responses, :encrypted_email_iv, :string
    add_column :responses, :encrypted_phone, :string
    add_column :responses, :encrypted_phone_iv, :string
    add_column :responses, :encrypted_age, :string
    add_column :responses, :encrypted_age_iv, :string
    add_column :responses, :encrypted_sex, :string
    add_column :responses, :encrypted_sex_iv, :string
  end
end
