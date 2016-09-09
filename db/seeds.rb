# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(ru_name: "Роман Козвонин", en_name: "Roman Kozvonin", password: "123456", password_confirmation: "123456", email: "romankozvonin@gmail.com", vk_url: '', fb_url: '', user_type_id: 1)
Category.create(
[
  {
    ru_name: "Природа",
    en_name: "Nature",
    ru_description: '',
    en_description: '',
    order_number: 1,
    is_enable: true
  },
  {
    ru_name: "Аэрофото",
    en_name: "Aerophoto",
    ru_description: '',
    en_description: '',
    order_number: 2,
    is_enable: true
  },
    {
      ru_name: "Путешествия",
      en_name: "Trips",
      ru_description: '',
      en_description: '',
      order_number: 3,
      is_enable: true
    },
    {
      ru_name: "Самара",
      en_name: "Samara",
      ru_description: '',
      en_description: '',
      order_number: 4,
      is_enable: true
    }
    
]
)