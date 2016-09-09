require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  setup do 
    @destroyTestPhoto = photos(:photo_for_destroy_test)
  end
  # test "the truth" do
  #   assert true
  # end
  
  test "makeTagReferences должна добавлять тэги и удалять если tagNames == '' или tagNames == '[]'" do
    ruTagsArr = tagStringGenerator(1010, 1030)
    enTagsArr = tagStringGenerator(1031, 1070)
    inScobes = ruTagsArr.getArrScobes.length + enTagsArr.getArrScobes.length
  	ph = photos(:five)
    if ph.update_attributes(ru_tag_names: ruTagsArr, com_tag_names: enTagsArr)
      l = ph.photo_tags.length
      assert l == inScobes, "Должно добавиться #{ inScobes}, добавилось #{l}"
    end
    if ph.update_attributes(ru_tag_names: '', com_tag_names: '')
      l = PhotoTagPhoto.where(photo_id: ph.id).count
      assert l == 0, "Должны удалиться все тэги"
    end
  end
  
  test "makeTagReferences должна добавлять тэги с разными атрибутами locale в зависимости от того какой входищий ru_tag_names или com_tag_names" do
    ruTagsArr = tagStringGenerator(2010, 2030, 'dif_test_ru')
    enTagsArr = tagStringGenerator(1031, 1070, 'dif_test_en')
  	ph_ru = photos(:dif_locale_test_ru)
    ph_en = photos(:dif_locale_test_en)
    if ph_ru.update_attributes(ru_tag_names: ruTagsArr, com_tag_names: '')
      l = ph_ru.photo_tags.where(locale: 'ru').count
      assert l == ruTagsArr.getArrScobes.length, "Должно добавиться #{ruTagsArr.getArrScobes.length}, добавилось #{l} в локали 'ru"
      assert ph_ru.photo_tags.first.locale == 'ru', "Записывались тэги с атрибутом locale = ru а записались #{ph_ru.photo_tags.first.locale}"
    end
    if ph_en.update_attributes(ru_tag_names: '', com_tag_names: enTagsArr)
      l = ph_en.photo_tags.where(locale: 'com').count
      assert l == enTagsArr.getArrScobes.length, "Должно добавиться #{enTagsArr.getArrScobes.length}, добавилось #{l} в локали 'com"
    end
  end
  
  test "makeTagReferences должна добавлять тэги которых нет и удалять те которые отвязаны" do
    ruTagsArr = tagStringGenerator(1, 30, 'ru_tag')
    enTagsArr = tagStringGenerator(1, 30, 'com_tag')
    frstTags = ruTagsArr.getArrScobes.length + enTagsArr.getArrScobes.length
    newRuTagsArr = tagStringGenerator(15, 40, 'ru_tag')
    newEnTagsArr = tagStringGenerator(20, 30, 'com_tag')
    newTags = ((newRuTagsArr.getArrScobes + newEnTagsArr.getArrScobes) - ((ruTagsArr.getArrScobes + enTagsArr.getArrScobes) - (newRuTagsArr.getArrScobes + newEnTagsArr.getArrScobes))).length
  	ph = photos(:five)
    assert_difference("PhotoTagPhoto.count", frstTags, "Должно добавиться #{frstTags}") do
      ph.update_attributes(ru_tag_names: ruTagsArr, com_tag_names: enTagsArr)
    end
    assert_difference("PhotoTagPhoto.count", newTags - frstTags, "Должно поменяться #{newTags}") do
      ph.update_attributes(ru_tag_names: newRuTagsArr, com_tag_names: newEnTagsArr)
    end

  end
  
  test "makeTagReferences должна добавлять тэги не создавая повторно уже существующие" do
  	ph = photos(:three)
    unusedTags = PhotoTagPhoto.unused_tags.length
  	tagsCollection_1 = tagStringGenerator(1, 5, 'ru_unique_tag')
    tagsCollection_2 = tagStringGenerator(1, 10, 'ru_unique_tag')
    name_arr_1 = tagsCollection_1.getArrScobes
    name_arr_2 = tagsCollection_2.getArrScobes
    assert_difference("PhotoTag.count", name_arr_1.length-unusedTags, "Не удалось добавить тэги") do
      ph.update_attributes(ru_tag_names: tagsCollection_1)
    end
    assert_difference("PhotoTag.count", name_arr_2.length - name_arr_1.length, "Тэги добавились дважды") do
      ph.update_attributes(ru_tag_names: tagsCollection_2)
    end
  end
  
  test "Должен удалять все ссылки вместе с фотографией" do
    PhotoTagPhoto.clear_unused_tag #для того, чтобы тест не находил неиспользуемые тэги до удаления
    references = PhotoTagPhoto.where(photo_id: @destroyTestPhoto.id).length
  	assert_difference(["PhotoTagPhoto.count", "PhotoTag.count"], -references, "Ссылка на тэг не удаляется вместе с фотографией") do
      @destroyTestPhoto.destroy
  	end
  end
end
