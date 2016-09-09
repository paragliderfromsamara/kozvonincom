json.array!(@photo_tag_references) do |photo_tag_reference|
  json.extract! photo_tag_reference, :id, :photo_id, :photo_tag_id
  json.url photo_tag_reference_url(photo_tag_reference, format: :json)
end
