require 'rails_helper'

RSpec.feature "Homepage", type: :feature do
  let(:partecipante) { create(:user) }
  let(:organizzatore)  { create(:user) }

  before do
    visit root_path
    fill_in "Email", with: partecipante.email
    fill_in "Password", with: partecipante.password
    click_button "Accedi"
    expect(current_path).to eq(events_path)
  end

  scenario "User visualizza che non ci sono eventi disponibili" do
    visit events_path

    expect(page).to have_content("Non ci sono eventi disponibili")
  end

  scenario "User visualizza eventi disponibili" do
    create(:event, nome: "Evento prova 1", user: organizzatore)
    create(:event, nome: "Evento prova 2", user: organizzatore)
    create(:event, nome: "Evento prova 3", user: organizzatore)

    visit events_path

    expect(page).to have_content("Evento prova 1")
    expect(page).to have_content("Evento prova 2")
    expect(page).to have_content("Evento prova 3")
  end

  scenario "User visualizza nessuna notifica ricevuta" do
    visit events_path

    expect(find("#navbarUserDropdown1")).to have_text("Notifiche (0)")
    find('#navbarUserDropdown1').click
    expect(page).to have_content("Non ci sono notifiche")
  end

  scenario "User visualizza notifiche non lette" do
    create(:notification, user: partecipante, messaggio: "Notifica prova 1", letto: nil)
    create(:notification, user: partecipante, messaggio: "Notifica prova 2", letto: nil)
    
    visit events_path

    expect(find("#navbarUserDropdown1")).to have_text("Notifiche (2)")
    find('#navbarUserDropdown1').click
    expect(page).to have_content("Notifica prova 1")
    expect(page).to have_content("Notifica prova 2")
  end

  scenario "User segna una notifica come letta" do
    create(:notification, user: partecipante, messaggio: "Notifica prova", letto: nil)
  
    visit events_path
  
    expect(find("#navbarUserDropdown1")).to have_text("Notifiche (1)")
    find("#navbarUserDropdown1").click
    expect(page).to have_content("Notifica prova")

    click_button "Segna come letto"
    
    expect(find("#navbarUserDropdown1")).to have_text("Notifiche (0)")
  end  

  scenario "User cerca eventi per città in cui non ce ne sono disponibili" do
    visit events_path

    fill_in "search_city", with: "Città di prova"
    click_button "Cerca"

    expect(page).to have_content("Non ci sono eventi disponibili")
  end

  scenario "User cerca eventi per città" do
    create(:event, nome: "Evento di prova", paese: "Città di prova", user: organizzatore)
  
    visit events_path
  
    fill_in "search_city", with: "Città di prova"
    click_button "Cerca"
  
    expect(page).to have_content("Evento di prova")
  end  
end