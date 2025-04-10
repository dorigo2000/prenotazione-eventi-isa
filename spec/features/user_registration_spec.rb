require 'rails_helper'

RSpec.feature "UserRegistrations", type: :feature do
  scenario "User partecipante registrazione con successo" do
    visit sign_up_path

    fill_in "user_nome", with: "Nome prova"
    fill_in "user_cognome", with: "Cognome prova"
    fill_in "user_telefono", with: "0123456789"
    fill_in "user_data_nascita", with: "2000/06/22"
    select "Partecipante", from: "user_tipo"
    fill_in "user_email", with: "prova@gmail.com"
    fill_in "user_password", with: "passwordprova"
    fill_in "user_password_confirmation", with: "passwordprova"
    click_button "Iscriviti"

    expect(page).to have_content("Registrazione completata con successo!")
  end

  scenario "User organizzatore registrazione con successo" do
    visit sign_up_path

    fill_in "user_nome", with: "Nome prova"
    fill_in "user_cognome", with: "Cognome prova"
    fill_in "user_telefono", with: "0123456789"
    fill_in "user_data_nascita", with: "2000/06/22"
    select "Organizzatore", from: "user_tipo"
    fill_in "user_email", with: "prova@gmail.com"
    fill_in "user_password", with: "passwordprova"
    fill_in "user_password_confirmation", with: "passwordprova"
    click_button "Iscriviti"

    expect(page).to have_content("Registrazione completata con successo!")
  end

  scenario "User registrazione con fallimento: dati mancanti" do
    visit sign_up_path

    fill_in "user_nome", with: ""
    fill_in "user_cognome", with: "Cognome prova"
    fill_in "user_telefono", with: "0123456789"
    fill_in "user_data_nascita", with: "2000/06/22"
    select "Organizzatore", from: "user_tipo"
    fill_in "user_email", with: "prova@gmail.com"
    fill_in "user_password", with: "passwordprova"
    fill_in "user_password_confirmation", with: "passwordprova"
    click_button "Iscriviti"

    expect(page).to have_content("Nome è obbligatorio")
  end

  scenario "User registrazione con fallimento: password non corrispondenti" do
    visit sign_up_path

    fill_in "user_nome", with: "Nome prova"
    fill_in "user_cognome", with: "Cognome prova"
    fill_in "user_telefono", with: "0123456789"
    fill_in "user_data_nascita", with: "2000/06/22"
    select "Organizzatore", from: "user_tipo"
    fill_in "user_email", with: "prova@gmail.com"
    fill_in "user_password", with: "passwordprova"
    fill_in "user_password_confirmation", with: "provapassword"
    click_button "Iscriviti"

    expect(page).to have_content("Le password non coincidono")
  end
end