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

  # Test for choices method
  test "choices returns empty array when nil" do
    @question.choices = nil
    assert_equal [], @question.choices
  end

  test "choices returns empty array when blank" do
    @question.choices = ""
    assert_equal [], @question.choices
  end

  test "choices splits on newlines" do
    @question.choices = "Option 1\nOption 2\nOption 3"
    assert_equal ["Option 1", "Option 2", "Option 3"], @question.choices
  end

  test "choices handles Windows line endings" do
    @question.choices = "Option 1\r\nOption 2\r\nOption 3"
    assert_equal ["Option 1", "Option 2", "Option 3"], @question.choices
  end

  # Test for inlineable? method
  test "inlineable? returns false for empty choices" do
    @question.choices = nil
    assert_equal false, @question.inlineable?

    @question.choices = ""
    assert_equal false, @question.inlineable?
  end

  test "inlineable? returns false for single choice that is too long" do
    @question.choices = "This is a very long choice that exceeds the thirty character limit"
    assert_equal false, @question.inlineable?
  end

  test "inlineable? returns true for short choices" do
    @question.choices = "Yes\nNo\nMaybe"
    assert_equal true, @question.inlineable?
  end

  test "inlineable? returns false for choices with too many words" do
    @question.choices = "This has four words here\nAnother choice"
    assert_equal false, @question.inlineable?
  end

  test "inlineable? returns false for choices with long average length" do
    @question.choices = "Short\nThis choice is very long and exceeds the average length limit"
    assert_equal false, @question.inlineable?
  end

  test "inlineable? works with nil choices (no NoMethodError)" do
    @question.choices = nil
    assert_equal false, @question.inlineable?
  end
end