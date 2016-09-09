class CreatePhotoTags < ActiveRecord::Migration
  def change
    create_table :photo_tags do |t|
      t.string :ru_name
      t.string :en_name
      
      t.timestamps null: false
    end
  end
end
