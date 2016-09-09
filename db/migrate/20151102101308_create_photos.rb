class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :album_id
      t.string :ru_name
      t.string :en_name
      t.string :ru_description
      t.string :en_description
      t.datetime :get_at
      t.string :link
      t.string :file_name
      t.boolean :is_enable
      t.boolean :is_album_photo
      t.boolean :is_category_photo
      
      t.timestamps null: false
    end
  end
end
