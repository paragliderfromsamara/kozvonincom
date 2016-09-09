json.array!(@categories) do |category|
  json.extract! category, :id, :ru_name, :en_name, :ru_description, :en_description, :order_number, :is_enable
  json.url category_url(category, format: :json)
end
