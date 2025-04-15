require 'rails_helper'

RSpec.feature "EventManagement", type: :feature do
  let(:organizzatore) { create(:user, tipo: "organizzatore") }
  let(:partecipante) { create(:user) }
  let!(:event) { create(:event, user: organizzatore, nome: "Evento prova")}

  before do
    visit root_path
    fill_in "Email", with: organizzatore.email
    fill_in "Password", with: organizzatore.password
    click_button "Accedi"
    expect(current_path).to eq(events_path)
  end

  scenario "User organizzatore crea evento con successo" do
    visit new_event_path

    fill_in "event_nome", with: "Evento di prova"
    fill_in "event_data_inizio", with: Date.tomorrow
    fill_in "event_orario_inizio", with: "10:00"
    fill_in "event_data_fine", with: Date.tomorrow
    fill_in "event_orario_fine", with: "15:00"
    fill_in "event_paese", with: "Milano"
    fill_in "event_indirizzo", with: "Via della Moscova 32"
    fill_in "event_max_partecipanti", with: 15
    click_button "Crea evento"

    expect(page).to have_content("Evento creato con successo!")
  end

  scenario "User organizzatore creazione evento con fallimento: dati mancanti" do
    visit new_event_path

    fill_in "event_nome", with: ""
    fill_in "event_data_inizio", with: Date.tomorrow
    fill_in "event_orario_inizio", with: "10:00"
    fill_in "event_data_fine", with: Date.tomorrow
    fill_in "event_orario_fine", with: "15:00"
    fill_in "event_paese", with: "Milano"
    fill_in "event_indirizzo", with: "Via della Moscova 32"
    fill_in "event_max_partecipanti", with: 15
    click_button "Crea evento"

    expect(page).to have_content("Nome evento è obbligatorio")
  end

  scenario "User organizzatore visualizza i propri eventi" do
    visit my_events_events_path

    expect(page).to have_content("Evento prova")
  end

  scenario "User organizzatore modifica evento con successo" do
    visit edit_event_path(event)

    fill_in "event_nome", with: "Evento di prova"
    click_button "Modifica"

    expect(page).to have_content("Evento modificato con successo!")
  end

  scenario "User organizzatore modifica evento con fallimento: dati mancanti" do
    visit edit_event_path(event)

    fill_in "event_nome", with: ""
    click_button "Modifica"

    expect(page).to have_content("Nome evento è obbligatorio")
  end

  scenario "User organizzatore elimina evento con successo" do
    visit my_events_events_path

    click_button "Elimina", match: :first

    expect(page).to have_content("Evento eliminato con successo!")
  end

  scenario "User organizzatore visualizza l'elenco dei partecipanti ad un proprio evento" do
    create(:subscription, user: partecipante, event: event)

    visit participants_event_path(event)

    expect(page).to have_content("#{partecipante.nome} #{partecipante.cognome}")
  end

  scenario "User organizzatore rimuove un partecipante dall'evento" do
    create(:subscription, user: partecipante, event: event)

    visit participants_event_path(event)

    click_button "Rimuovi", match: :first

    expect(page).to have_content("#{partecipante.nome} #{partecipante.cognome} è stato rimosso dall'evento.")
  end
end