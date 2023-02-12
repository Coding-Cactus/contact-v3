require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index,new,create" do
    get comments_index,new,create_url
    assert_response :success
  end
end
