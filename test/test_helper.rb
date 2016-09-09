ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def tagStringGenerator(start=0, finish=10, name = 'тэг')
    a = ""
    for i in start..finish 
      a += "[#{name}#{i}]"
    end
    return a
  end
  
  def baseTagsString
	a = ""
	for i in 1..10
		a += "[тэг#{i}]"
	end
	return a
  end
  def newTagsString
	a = ""
	for i in 1..25
		a += "[тэг#{i}]"
	end
	return a
  end
  def midTagsString
	a = ""
	for i in 5..10
		a += "[тэг#{i}]"
	end
	return a
  end
  def unusedTags
	a = ""
	for i in 1..20
		a += "[неиспользуемыйтэг#{i}]"
	end
	return a
  end
  def tagsSum
	arr = baseTagsString + newTagsString
	arrConverted = arr.getArrScobes
	return arrConverted.uniq
  end

end
