require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Не должден сохранять категорию с существующим именем" do
	ru_name = "Match category ru_name"
  com_name = "Match category com_name"
	cat_1 = Category.new(ru_name: ru_name, com_name: com_name)
	assert cat_1.save, "Не удалось сохранить категорию с несуществующим именем"
	cat_2 = Category.new(ru_name: ru_name, com_name: com_name)
	assert_not cat_2.save, "Удалось сохранить категорию с существующим именем"
	cat_3 = Category.new(ru_name: ru_name, com_name: com_name)
	assert_not cat_3.save, "Удалось сохранить категорию с существующим именем в другом регистре"
  end
  
end
