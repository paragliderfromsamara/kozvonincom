class RenameColumnsEnglishLocale < ActiveRecord::Migration[5.0]
  def change
    rename_column :categories, :en_name, :com_name
    rename_column :categories, :en_description, :com_description
    rename_column :albums, :en_name, :com_name
    rename_column :albums, :en_content, :com_content
    rename_column :photos, :en_name, :com_name
    rename_column :photos, :en_description, :com_description
    rename_column :users, :en_name, :com_name
  end
end
