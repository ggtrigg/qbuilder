require "application_system_test_case"
include Warden::Test::Helpers

class QuestionnairesTest < BrowserSystemTestCase
  setup do
    @user = FactoryBot.create(:user)
    login_as @user, scope: :user
  end

  test "visiting the index" do
    visit questionnaires_url
    assert_selector "h1", text: "Questionnaires"
  end

  test "creating a Questionnaire" do
    title = Faker::Alphanumeric.alpha(number: 15)
    visit questionnaires_url
    click_on "New Questionnaire"
    assert_selector "h1", text: "New Questionnaire"
    assert_selector "h3", text: "Step 1."

    fill_in "Title", with: title
    click_on "Add questions"

    assert_selector "h1", text: title
    assert_selector "button", text: "Details"
    assert_selector "button", text: "Questions"

    click_on "Questions"
    assert_selector ".btn", text: "Add Question"
    click_on "Add Question"
    assert_selector "h3", text: "New Question"
    fill_in "Question text", with: "My question text"
    select "True false", from: "Answer type"
    click_on "Save Question"

    assert_selector ".btn", text: "Add Question"

    question = Question.last
    assert_selector "li.row[id='question_#{question.id}']"
    assert_text "My question text"
  end

  test "updating a Questionnaire" do
    qnn = FactoryBot.create(:questionnaire, user: @user, title: "The questionnaire title")
    visit questionnaires_url
    assert_selector "h1", text: "Questionnaires"
    click_on qnn.title
    assert_selector "button", text: "Details"
    assert_selector "button", text: "Questions"
    click_on "Edit"
    assert_selector "input", text: "Save"

    fill_in "Title", with: "The new questionnaire title"
    click_on "Save"

    assert_selector "h1", text: "The new questionnaire title"
    assert qnn.reload.title == "The new questionnaire title"
  end

  test "destroying a Questionnaire" do
    qnn = FactoryBot.create(:questionnaire, user: @user)
    visit questionnaire_url(qnn)
    # assert_selector "h1", text: qnn.title
    assert_selector "a", text: "Delete"
    page.accept_confirm do
      click_on "Delete"
    end

    assert_text "Questionnaire was successfully deleted"
  end
end
