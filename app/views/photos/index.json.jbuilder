json.array!(@photos) do |photo|
  json.extract! photo, :id, :album_id, :name, :description, :get_at, :link
  json.url photo_url(photo, format: :json)
end
