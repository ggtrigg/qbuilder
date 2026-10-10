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

  test "value handles yes_no type" do
    @question.answer_type = "yes_no"
    @answer.yes_no = true
    assert_equal "Yes", @answer.value
    @answer.yes_no = false
    assert_equal "No", @answer.value
  end

  test "value handles true_false type" do
    @question.answer_type = "true_false"
    @answer.yes_no = true
    assert_equal "True", @answer.value
    @answer.yes_no = false
    assert_equal "False", @answer.value
  end

  test "value handles multiple_choice_single with valid index" do
    @question.answer_type = "multiple_choice_single"
    @question.choices = "Red\nGreen\nBlue"
    @answer.choice = "1"
    assert_equal "Green", @answer.value
  end

  test "value handles out-of-bounds index in multiple_choice_single" do
    @question.answer_type = "multiple_choice_single"
    @question.choices = "A\nB\nC"
    @answer.choice = "10"
    assert_equal "(invalid choice)", @answer.value
  end

  test "value handles negative index in multiple_choice_single" do
    @question.answer_type = "multiple_choice_single"
    @question.choices = "A\nB\nC"
    @answer.choice = "-1"
    assert_equal "(invalid choice)", @answer.value
  end

  test "value handles multiple_choice_any with valid indices" do
    @question.answer_type = "multiple_choice_any"
    @question.choices = "A\nB\nC\nD"
    @answer.choice = "[0, 2]"
    assert_equal "A, C", @answer.value
  end

  test "value handles invalid JSON in multiple_choice_any" do
    @question.answer_type = "multiple_choice_any"
    @question.choices = "A\nB\nC"
    @answer.choice = "not valid json"
    assert_equal "(invalid choices data)", @answer.value
  end

  test "value handles empty array in multiple_choice_any" do
    @question.answer_type = "multiple_choice_any"
    @question.choices = "A\nB\nC"
    @answer.choice = "[]"
    assert_equal "(No choices selected)", @answer.value
  end

  test "value filters out nil from values_at for out-of-bounds indices" do
    @question.answer_type = "multiple_choice_any"
    @question.choices = "A\nB\nC"
    @answer.choice = "[0, 5, 2]"
    assert_equal "A, C", @answer.value
  end

  test "value handles multiple_choice_any with no choices selected" do
    @question.answer_type = "multiple_choice_any"
    @question.choices = "A\nB\nC"
    @answer.choice = nil
    assert_equal "(No choices selected)", @answer.value
    @answer.choice = ""
    assert_equal "(No choices selected)", @answer.value
  end

  test "value handles score type" do
    @question.answer_type = "score"
    @answer.choice = "7"
    assert_equal 7, @answer.value
  end
end