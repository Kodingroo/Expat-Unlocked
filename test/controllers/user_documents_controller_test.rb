require 'test_helper'

class UserDocumentsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "should get index" do
    get user_documents_index_url
    assert_response :success
  end

  test "should get create" do
    get user_documents_create_url
    assert_response :success
  end

  test "should get show" do
    get user_documents_show_url
    assert_response :success
  end

  test "should get update" do
    get user_documents_update_url
    assert_response :success
  end
end
