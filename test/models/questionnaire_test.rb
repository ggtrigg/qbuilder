# test/models/questionnaire_test.rb

require "test_helper"

class QuestionnaireTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  # Test for validations
  test "should not save questionnaire without title" do
    questionnaire = Questionnaire.new
    assert_not questionnaire.save, "Saved the questionnaire without a title"
  end

  test "should save questionnaire with long description" do
    questionnaire = Questionnaire.new(
      title: "Sample Title",
      user: @user,
      description: Faker::String.random(length: 1001)
    )
    assert questionnaire.save, "Saved the questionnaire with a long description"
  end

  # Test for associations
  test "should have many questions" do
    assert_respond_to Questionnaire.new, :questions
  end

  test "should have many responses" do
    assert_respond_to Questionnaire.new, :responses
  end

  test "should belong to user" do
    assert_respond_to Questionnaire.new, :user
  end

  # Test for custom methods
  test "editable? returns expected result" do
    questionnaire = Questionnaire.new
    assert_equal true, questionnaire.editable?
    questionnaire.responses << Response.new
    assert_equal false, questionnaire.editable?
  end

  test "r_attributes returns expected result" do
    questionnaire = Questionnaire.new
    assert_equal %w[name], questionnaire.r_attributes
    questionnaire.r_age = true
    assert_equal %w[name age], questionnaire.r_attributes
  end

  test "redirect_delay_secs returns expected result" do
    questionnaire = Questionnaire.new
    assert_equal 15, questionnaire.redirect_delay_secs
    questionnaire.redirect_delay_secs = 30
    assert_equal 30, questionnaire.redirect_delay_secs
  end
end
