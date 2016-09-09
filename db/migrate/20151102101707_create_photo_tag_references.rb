class CreatePhotoTagReferences < ActiveRecord::Migration
  def change
    create_join_table :photos, :photo_tag, column_options: {null: true}
  end
end
