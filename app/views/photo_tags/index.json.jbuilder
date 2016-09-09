json.array!(@photo_tags) do |photo_tag|
  json.extract! photo_tag, :id, :name
  json.url photo_tag_url(photo_tag, format: :json)
end
