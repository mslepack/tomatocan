require "test_helper"
require "capybara-screenshot/minitest"

class UserEditsEvent < ActionDispatch::IntegrationTest
  setup do
    @test_user  = users :confirmedUser
    @test_event_one = events :three

    user_sign_in @test_user

    visit edit_event_path @test_event_one
  end

  test "visits edit event page successfully" do
    page.status_code == 200
  end

  test "update event with invalid attributes" do
    fill_in id: "event_name", with: ""
    fill_in id: "event_desc", with: "http://www.thinq.tv/"

    click_on class: "btn btn-lg btn-primary update-event-btn"

    assert_equal current_path, event_path(@event)
    assert page.has_css? "#error_explanation"
  end

  test "update event with valid attributes" do
    fill_in id: "event_name", with: "Title of Conversation"
    fill_in id: "event_desc", with: "Details about Conversation Topic"

    select "2020", from: "event_start_at_1i"
    select "July", from: "event_start_at_2i"
    select "16", from: "event_start_at_3i"
    select "03 PM", from: "event_start_at_4i"
    select "00", from: "event_start_at_5i"

    # select "2020", from: "event_end_at_1i"
    # select "July", from: "event_end_at_2i"
    # select "16", from: "event_end_at_3i"
    # select "04 PM", from: "event_end_at_4i"
    # select "00", from: "event_end_at_5i"

    click_on class: "btn btn-lg btn-primary update-event-btn"

    assert current_path, event_path(@event)

    assert page.has_content? "Title of Conversation"
    assert page.has_content? "Details about Conversation Topic"
  end

  private

  def sign_in
    visit root_path

    click_on('Sign In', match: :first)

    fill_in(id: 'user_email', with: 'thinqtesting@gmail.com')
    fill_in(id: 'user_password', with: 'user1234')

    click_on(class: 'form-control btn-primary')
  end
end
