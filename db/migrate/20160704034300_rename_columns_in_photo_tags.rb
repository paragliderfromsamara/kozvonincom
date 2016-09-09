class RenameColumnsInPhotoTags < ActiveRecord::Migration[5.0]
  def change
    rename_column :photo_tags, :ru_name, :name
    rename_column :photo_tags, :en_name, :locale
    remove_timestamps :photo_tags
    remove_timestamps :categories
  end
end
