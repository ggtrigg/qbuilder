require "application_system_test_case"
include Warden::Test::Helpers

class ResponsesFlowTest < BrowserSystemTestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_on "Log in"
    assert_selector "h1", text: "Questionnaires"
  end

  test "complete happy path: login -> create questionnaire -> anonymous submit response" do
    # 1. Login through UI
    sign_in(@user)
    visit questionnaires_url
    assert_selector "h1", text: "Questionnaires"

    # 2. Create a questionnaire with questions
    title = "Test Questionnaire #{SecureRandom.hex(4)}"
    # visit questionnaires_url
    click_on "New Questionnaire"
    assert_selector "h1", text: "New Questionnaire"
    assert_selector "h3", text: "Step 1."

    fill_in "Title", with: title
    click_on "Add questions"

    assert_selector "h1", text: title
    click_on "Questions"
    assert_selector ".btn", text: "Add Question"

    # Add a single line text question
    click_on "Add Question"
    assert_selector "h3", text: "New Question"
    fill_in "Question text", with: "What is your favorite color?"
    select "Single line", from: "Answer type"
    click_on "Save Question"

    # Add a true/false question (uses True/False labels)
    click_on "Add Question"
    fill_in "Question text", with: "Do you like pizza?"
    select "True false", from: "Answer type"
    click_on "Save Question"

    # Add a multiple choice question - need to select type first, then fill choices
    click_on "Add Question"
    fill_in "Question text", with: "What is your age group?"
    select "Multiple choice single", from: "Answer type"
    # Wait for choices field to appear (Stimulus controller)
    assert_selector "textarea#question_choices", visible: true
    fill_in "Choices", with: "Under 18\n18-25\n26-35\n36-50\nOver 50"
    click_on "Save Question"

    # Verify questions were created
    assert_text "What is your favorite color?"
    assert_text "Do you like pizza?"
    assert_text "What is your age group?"

    # Get the questionnaire ID for direct link
    questionnaire = Questionnaire.find_by(title: title)

    # 3. Access questionnaire response form as anonymous user
    # Anonymous users can access the response form directly without authentication
    # Open a new browser session to simulate anonymous user
    page.driver.browser.manage.delete_all_cookies
    visit new_questionnaire_response_path(questionnaire)

    # Should be on response form
    assert_selector "h1", text: title
    assert_selector "input#response_name"

    # 4. Submit a response as anonymous user
    fill_in "Name", with: "Anonymous User"
    fill_in "What is your favorite color?", with: "Blue"
    choose "True", allow_label_click: true  # for true/false question
    choose "26-35", allow_label_click: true  # for multiple choice

    click_on "Submit Reponse"

    # Wait for Turbo response - anonymous users see form re-rendered (no redirect implemented)
    assert_selector "h1", text: title

    # 5. Log back in and verify response was recorded
    visit new_user_session_path
    sign_in(@user)
    visit questionnaire_responses_path(questionnaire)

    # Verify response appears in list (shows name)
    assert_text "Anonymous User"

    # Click on the response to see details
    click_on "Anonymous User"

    # Verify answer content on show page
    assert_text "Blue"
    assert_text "True"
    assert_text "26-35"
  end

  test "logged in user can submit response to own questionnaire" do
    # Login
    sign_in(@user)

    # Create questionnaire
    title = "My Questionnaire #{SecureRandom.hex(4)}"
    visit questionnaires_url
    click_on "New Questionnaire"
    fill_in "Title", with: title
    click_on "Add questions"
    click_on "Questions"
    click_on "Add Question"
    fill_in "Question text", with: "Test question?"
    select "Single line", from: "Answer type"
    click_on "Save Question"

    # Submit response while logged in
    questionnaire = Questionnaire.find_by(title: title)
    visit new_questionnaire_response_path(questionnaire)

    assert_selector "input#response_name"
    fill_in "Name", with: "Me"
    fill_in "Test question?", with: "My answer"
    click_on "Submit Reponse"

    # Wait for redirect to response show page
    assert_selector "h1", text: title

    # Verify response show page content
    assert_text "Question 1."
    assert_text "Test question?"
    assert_text "My answer"
  end
end
