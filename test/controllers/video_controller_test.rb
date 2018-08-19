require 'test_helper'

class VideoControllerTest < ActionDispatch::IntegrationTest
  test "should get check" do
    get video_check_url
    assert_response :success
  end

  test "should get convert" do
    get video_convert_url
    assert_response :success
  end

end
