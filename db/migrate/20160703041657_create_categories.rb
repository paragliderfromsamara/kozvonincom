class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :ru_name
      t.string :en_name
      t.string :ru_description
      t.string :en_description
      t.integer :order_number
      t.boolean :is_enable

      t.timestamps null: false
    end
  end
end
