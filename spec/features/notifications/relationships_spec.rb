require "rails_helper"

feature "relationships" do
  scenario "following a user" do
    bob = create :user
    alice = create :user, username: "alice"

    visit user_path(bob, as: alice)
    click_button "Follow"

    visit root_path(bob, as: bob)
    click_link "Notifications (1)"

    expect(page).to have_content "@alice started following you"
  end
end
