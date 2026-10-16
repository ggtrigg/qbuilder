require "test_helper"

class ResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @questionnaire = FactoryBot.create(:questionnaire, user: @user)
    @question = FactoryBot.create(:question, questionnaire: @questionnaire, answer_type: :single_line)
  end

  test "should get new response form" do
    get new_questionnaire_response_url(@questionnaire)
    assert_response :success
  end

  test "should create response with valid data" do
    assert_difference("Response.count", 1) do
      post questionnaire_responses_url(@questionnaire), params: {
        response: {
          name: "Test User",
          answers_attributes: {
            "0" => { question_id: @question.id, atext: "My answer" }
          }
        }
      }
      puts "POST COMPLETED, status: #{response.status}, location: #{response.location}"
    end
    assert_response :success
  end

  test "should accept response when honeypot is empty" do
    assert_difference("Response.count", 1) do
      post questionnaire_responses_url(@questionnaire), params: {
        response: {
          name: "Real User",
          answers_attributes: {
            "0" => { question_id: @question.id, atext: "My answer" }
          }
        }
      }
    end
    assert_response :success
  end

  test "should not allow access to responses index without authentication" do
    get questionnaire_responses_url(@questionnaire)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should allow owner to access responses index" do
    sign_in @user
    get questionnaire_responses_url(@questionnaire)
    assert_response :success
  end

  test "should allow admin to access responses index" do
    admin = FactoryBot.create(:user, admin: true)
    sign_in admin
    get questionnaire_responses_url(@questionnaire)
    assert_response :success
  end

  test "should not allow non-owner to access responses index" do
    other_user = FactoryBot.create(:user)
    sign_in other_user
    get questionnaire_responses_url(@questionnaire)
    assert_response :redirect
    assert_equal "Not authorized.", flash[:alert]
  end

  test "should allow owner to show response" do
    response = FactoryBot.create(:response, questionnaire: @questionnaire)
    sign_in @user
    get questionnaire_response_url(@questionnaire, response)
    assert_response :success
  end

  test "should allow owner to destroy response" do
    response = FactoryBot.create(:response, questionnaire: @questionnaire)
    sign_in @user
    assert_difference("Response.count", -1) do
      delete questionnaire_response_url(@questionnaire, response)
    end
    assert_response :redirect
  end

  test "should not allow non-owner to destroy response" do
    # Create a response for @user's questionnaire
    response = FactoryBot.create(:response, questionnaire: @questionnaire)
    other_user = FactoryBot.create(:user)
    sign_in other_user
    assert_no_difference("Response.count") do
      delete questionnaire_response_url(@questionnaire, response)
    end
    assert_response :redirect
    assert_equal "Not authorized.", flash[:alert]
  end

  test "should allow admin to destroy any response" do
    response = FactoryBot.create(:response, questionnaire: @questionnaire)
    admin = FactoryBot.create(:user, admin: true)
    sign_in admin
    assert_difference("Response.count", -1) do
      delete questionnaire_response_url(@questionnaire, response)
    end
    assert_response :redirect
  end

  test "should allow non-owner to create response (public form)" do
    other_user = FactoryBot.create(:user)
    sign_in other_user
    assert_difference("Response.count", 1) do
      post questionnaire_responses_url(@questionnaire), params: {
        response: {
          name: "Public User",
          answers_attributes: {
            "0" => { question_id: @question.id, atext: "My answer" }
          }
        }
      }
    end
    assert_response :success
  end

  private

  def sign_in(user)
    post user_session_url, params: { user: { email: user.email, password: "password" } }
  end
end
