# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(ru_name: "Роман Козвонин", com_name: "Roman Kozvonin", password: "123456", password_confirmation: "123456", email: "romankozvonin@gmail.com", vk_url: '', fb_url: '', user_type_id: 1)
Category.create(
[
  {
    ru_name: "Природа",
    com_name: "Nature",
    ru_description: '',
    com_description: '',
    order_number: 1,
    is_enable: true
  },
  {
    ru_name: "Аэрофото",
    com_name: "Aerophoto",
    ru_description: '',
    com_description: '',
    order_number: 2,
    is_enable: true
  },
    {
      ru_name: "Путешествия",
      com_name: "Trips",
      ru_description: '',
      com_description: '',
      order_number: 3,
      is_enable: true
    },
    {
      ru_name: "Самара",
      com_name: "Samara",
      ru_description: '',
      com_description: '',
      order_number: 4,
      is_enable: true
    }
    
]
)