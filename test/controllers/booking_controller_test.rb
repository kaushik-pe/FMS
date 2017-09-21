require 'test_helper'

class BookingControllerTest < ActionDispatch::IntegrationTest
  test "should get homepage" do
    get booking_homepage_url
    assert_response :success
  end

  test "should get list" do
    get booking_list_url
    assert_response :success
  end

end
