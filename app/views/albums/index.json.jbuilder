json.array!(@albums) do |album|
  json.extract! album, :id, :category_id, :name, :get_at
  json.url album_url(album, format: :json)
end
