class AddBgOpacityToPhoto < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :bg_opacity, :float, default: 1.0
    change_column_default :photos, :is_album_photo, from: nil, to: false
    change_column_default :photos, :is_category_photo, from: nil, to: false
    change_column_default :photos, :is_enable, from: nil, to: false
    change_column_default :categories, :is_enable, from: nil, to: false
    change_column_default :albums, :is_enable, from: nil, to: false
  end
end
