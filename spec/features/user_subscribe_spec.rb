require 'rails_helper'

RSpec.feature "UserSubscibe", type: :feature do
  let(:partecipante) { create(:user) }
  let(:organizzatore) { create(:user, tipo: "organizzatore") }
  let!(:event) { create(:event, user: organizzatore, data_inizio: Date.tomorrow, data_fine: Date.tomorrow, orario_inizio: "10:00", orario_fine: "12:00", max_partecipanti: 10)}
  let!(:event2) { create(:event, user: organizzatore, data_inizio: Date.tomorrow, data_fine: Date.tomorrow, orario_inizio: "15:00", orario_fine: "17:00", max_partecipanti: 10)}

  before do
    visit root_path
    fill_in "Email", with: partecipante.email
    fill_in "Password", with: partecipante.password
    click_button "Accedi"
    expect(current_path).to eq(events_path)
  end

  scenario "User partecipante si iscrive ad un evento" do
    visit events_path

    within("[data-event-id='#{event.id}']") do
      click_button("Iscriviti")
    end
    expect(page).to have_content("Iscrizione effettuata con successo!")
  end

  scenario "User partecipante visualizza le proprie iscrizioni" do
    create(:subscription, user: partecipante, event: event)

    visit subscriptions_path

    expect(page).to have_content("#{event.nome}")
  end

  scenario "User partecipante cancella l'iscrizione ad un evento" do
    visit events_path
    
    within("[data-event-id='#{event.id}']") do
      click_button("Iscriviti")
    end
    expect(page).to have_content("Iscrizione effettuata con successo!")
  
    visit subscriptions_path
    within("[data-event-id='#{event.id}']") do
      click_button("Elimina")
    end
    expect(page).to have_content("La tua iscrizione è stata cancellata con successo!")
  end

  scenario "User partecipante non può iscriversi a due eventi nella stessa data" do
    visit events_path 
    click_button "Iscriviti", match: :first

    visit events_path
    within("[data-event-id='#{event2.id}']") do
      click_button "Iscriviti"
    end
    expect(page).to have_content("Impossibile effettuare l'iscrizione, sei già iscritto a un evento nella stessa data!")
  end
end