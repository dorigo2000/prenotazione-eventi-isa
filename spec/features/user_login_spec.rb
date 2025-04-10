require 'rails_helper'

RSpec.feature "UserLogin", type: :feature do
  let(:user) { create(:user) }

  scenario "User login effettuato con successo" do
    visit root_path

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Accedi"

    expect(current_path).to eq(events_path)
  end

  scenario "User login fallito per credenziali errate" do
    visit root_path

    fill_in "Email", with: user.email
    fill_in "Password", with: "123password"
    click_button "Accedi"

    expect(page).to have_text("Siamo spiacenti, le credenziali sono errate!")
  end

  scenario "User logout effettuato con successo" do
    visit root_path

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Accedi"

    expect(current_path).to eq(events_path)

    click_button "Logout"

    expect(page).to have_text("Logout completato con successo!")
  end
end