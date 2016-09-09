class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :category_id
      t.boolean :is_enable, default: false
      t.boolean :is_draft, default: false
      t.string :ru_name
      t.string :en_name
      t.string :ru_content
      t.string :en_content
      t.datetime :get_at
      

      t.timestamps null: false
    end
  end
end
