class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :ru_name
      t.string :en_name
      t.string :encrypted_password
      t.string :salt
      t.string :email
      t.string :vk_url
      t.string :fb_url
      t.integer :user_type_id
      
      t.timestamps null: false
    end
  end
end
