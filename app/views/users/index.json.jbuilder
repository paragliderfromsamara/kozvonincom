json.array!(@users) do |user|
  json.extract! user, :id, :ru_name, :en_name, :encrypted_password, :salt, :email, :vk_url, :fb_url
  json.url user_url(user, format: :json)
end
