require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_url
    assert_selector "a.btn", text: "Log in"
    assert_selector "a.btn", text: "Sign up"
  end

  test "successful log in" do
    user = FactoryBot.create(:user)
    visit root_url
    click_on "Log in"
    assert_selector "h2", text: "Log in"
    assert_selector "input[type=email]"
    assert_selector "input[type=password]"
    assert_selector "input[type=submit]"
    fill_in "Email", with: user.email
    fill_in "Password", with: 'password'
    click_on "Log in"
    assert_selector "h1", text: "Questionnaires"
  end

  test "unsuccessful log in" do
    user = FactoryBot.create(:user)
    visit root_url
    click_on "Log in"
    assert_selector "h2", text: "Log in"
    assert_selector "input[type=email]"
    assert_selector "input[type=password]"
    assert_selector "input[type=submit]"
    fill_in "Email", with: user.email
    fill_in "Password", with: 'pazzword'
    click_on "Log in"
    assert_selector "h2", text: "Log in"
    # assert_selector "div", text: "Invalid email or password"
  end
end