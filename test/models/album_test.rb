require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
	test "Не должен сохранять альбом без названия если он не черновик" do
		album = Album.new(name: "", category: categories(:one), is_draft: false, is_enable: true)
		assert_not album.save
	end
	test "Должен сохранять альбом без названия если он черновик" do
		album = Album.new(name: "", category: categories(:one), is_draft: true, is_enable: true)
		assert album.save
	end
	test "Должен сохранять альбом и разделять название и описание по локалям" do
    ru = "Русское название"
    en = "English name"
		album = Album.new(name: "#{ru}{#{en}}", content: "#{ru}{#{en}}", category: categories(:one), is_draft: false, is_enable: true)
		assert album.save, "Не удалось сохранить альбом"
    assert album.ru_name == ru, "Имя на русском не соответствует введенному"
    assert album.com_name == en, "Имя на английском не соответствует введенному" 
    assert album.ru_content == ru, "Контент на русском не соответствует введенному"
    assert album.com_content == en, "Контент на английском не соответствует введенному"
	end
	test "Статусы альбомов" do
    enabled = albums(:enabled)
    disabled = albums(:disabled)
    enabled_draft = albums(:enabled_draft)
    disabled_draft = albums(:disabled_draft)
    assert enabled.status == "Активен", "Активный альбом не отображается как активный"
    assert disabled.status == "Не активен", "Не активный альбом не отображается как не активный"
    assert enabled_draft.status == "Черновик", "Активный черновик не отображается как черновик"
    assert disabled_draft.status == "Черновик", "Не активный черновик не отображается как черновик"
	end
end
