# test/models/response_test.rb

require "test_helper"

class ResponseTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
    @questionnaire = FactoryBot.create(:questionnaire, user: @user)
    @question = FactoryBot.create(:question, questionnaire: @questionnaire)
    @response = Response.new(questionnaire: @questionnaire)
  end

  # Test for validations
  test "should not save response without answer" do
    @response.name = nil
    assert_not @response.save, "Saved the response without a name"
  end

  test "should save valid response" do
    @response.name = "Sample Name"
    assert @response.save, "Failed to save a valid response"
    @questionnaire.r_age = true
    assert_not @response.save, "Saved the response without an age"
    @response.age = 25
    assert @response.save, "Failed to save a valid response"
    @questionnaire.r_sex = true
    assert_not @response.save, "Saved the response without a sex"
    @response.sex = "male"
    assert @response.save, "Failed to save a valid response"
  end

  # Test for associations
  test "should belong to questionnaire" do
    assert_respond_to Response.new, :questionnaire
  end
end
