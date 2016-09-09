require 'test_helper'

class PhotoTagPhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  
  test "clear_unused_tag должна удалять неиспользуемые TagName если они нигде не используются" do
    unusedTags = PhotoTagPhoto.unused_tags
    assert_difference("PhotoTag.count", -unusedTags.length) do
      PhotoTagPhoto.clear_unused_tag
    end
  end
 
end
