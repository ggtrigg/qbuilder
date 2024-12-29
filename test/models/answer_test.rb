# test/models/answer_test.rb

require "test_helper"

class AnswerTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
    @questionnaire = FactoryBot.create(:questionnaire, user: @user)
    @question = FactoryBot.create(:question, questionnaire: @questionnaire)
    @response = FactoryBot.create(:response, questionnaire: @questionnaire)
    @answer = Answer.new(question: @question, response: @response)
  end

  # Test for validations
  test "should not save answer without value" do
    @question.answer_type = "single_line"
    @answer.atext = nil
    assert_not @answer.save, "Saved the answer without a value"
    @question.answer_type = "multi_line"
    assert_not @answer.save, "Saved the answer without a value"
  end

  test "should save valid answer" do
    @question.answer_type = "single_line"
    @answer.atext = "Sample Answer"
    assert @answer.save, "Failed to save a valid answer"
    @question.answer_type = "multi_line"
    assert @answer.save, "Failed to save a valid answer"
  end

  # Test for associations
  test "should belong to question" do
    assert_respond_to Answer.new, :question
  end

  test "should belong to response" do
    assert_respond_to Answer.new, :response
  end

  # Test for custom methods
  test "value returns expected result" do
    @question.answer_type = "single_line"
    @answer.atext = "Sample Answer"
    assert_equal "Sample Answer", @answer.value
    @answer.atext = "Updated Answer"
    assert_equal "Updated Answer", @answer.value
  end
end
