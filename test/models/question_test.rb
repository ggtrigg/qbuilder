# test/models/question_test.rb

require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
    @questionnaire = FactoryBot.create(:questionnaire, user: @user)
    @question = Question.new(blurb: "This is a question", questionnaire: @questionnaire)
  end

  # Test for validations
  test "should not save question without blurb" do
    @question.blurb = nil
    assert_not @question.save, "Saved the question without a blurb"
  end

  test "should save valid question" do
    assert @question.save, "Failed to save a valid question"
  end

  # Test for associations
  test "should belong to questionnaire" do
    assert_respond_to Question.new, :questionnaire
  end

  # Test for custom methods
  test "to_range returns expected result" do
    assert_equal 1..10, @question.to_range
    @question.score_range = "5..15"
    assert_equal 5..15, @question.to_range
    @question.score_range = "1-8"
    assert_equal 1..8, @question.to_range
  end
end
