require 'test_helper'

class PhotoTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Не должен позволять создать тег с существующим названием в одной локали" do
	  tName = "мойтэг"
	  tag_1 = PhotoTag.new(name: tName, locale: "ru")
    assert tag_1.save, "Не удалось сохранить тэг с уникальным названием"
	  tag_2 = PhotoTag.new(name: tName, locale: "ru")
	  assert_not tag_2.save, "Удалось сохранить тэг с существующим названием"
  end
  
  test "Должен позволять создать тег с существующим названием в разных локалях" do
	  tName = "MyTag2"
	  tag_1 = PhotoTag.new(name: tName, locale: "ru")
    assert tag_1.save, "Не удалось сохранить тэг с уникальным названием"
	  tag_2 = PhotoTag.new(name: tName, locale: "com")
	  assert tag_2.save, "Не удалось сохранить тэг с существующим названием в другой локали"
  end
  
  test "Должен конвертировать имя в нижний регистр" do
	tName = "ТестоВыйТэг"
	nameDc = "тестовыйтэг"
	tag = PhotoTag.new(name: tName)
	assert tag.save, "Не удалось сохранить тэг"
	assert tag.name == nameDc, "Тэг остался в верхнем регистре"
  end
  
  test "Должен возвращать тэг: если есть-существующий; если нет создавать новый и возвращать его" do
	nameForNewTag = "namefornewtag"
	existsTestTag = photo_tags(:testTag)
	tag_1 = PhotoTag.new(name: existsTestTag.name, locale: 'ru')
	assert existsTestTag == tag_1.getTagByName, "Не удалось найти существующий тэг"
	tag_2 = PhotoTag.new(name: nameForNewTag, locale: 'ru')
	assert_difference('PhotoTag.count', 1,"Не удалось добавить несуществующий тэг") { tag_2.getTagByName}
  end
  
  test "Должен создавать тэги из массива" do
	arr = baseTagsString.getArrScobes
	assert_difference('PhotoTag.count', arr.length,"Не удалось добавить массив #{arr}") do
		arr.each do |i|
			PhotoTag.new(name: i, locale: 'ru').getTagByName
		end
	end
  end

  
end
