require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:organizzatore) { create(:user) }
  let(:partecipante) { create(:user) }

  before do
    session[:user_id] = organizzatore.id
  end

  describe "GET #index" do
    it "reindirizza alla schermata di login se l'utente non è loggato" do
      session[:user_id] = nil
      get :index
      expect(response).to redirect_to(root_path)
    end

    it "visualizza che non ci sono eventi disponibili" do
      get :index

      expect(response).to be_successful
      expect(assigns(:events)).to be_empty
    end
  
    it "visualizza eventi disponibili" do
      evento = create(:event, user: organizzatore, data_inizio: Date.tomorrow)

      get :index

      expect(response).to be_successful
      expect(assigns(:events)).to include(evento)
    end

    it "ricerca eventi per città" do
      create(:event, paese: "Città di prova", user: organizzatore)

      get :index, params: { search_city: "Città di prova" }

      expect(assigns(:events).pluck(:paese)).to include("Città di prova")
    end
  end

  describe "GET #my_events" do
    it "visualizza gli eventi creati dall'organizzatore" do
      event = create(:event, user: organizzatore)

      get :my_events

      expect(assigns(:events)).to include(event)
    end
  end

  describe "POST #create" do
    it "crea un evento valido" do
      expect {
        post :create, params: {
          event: attributes_for(:event)
        }
      }.to change(Event, :count).by(1)

      expect(response).to redirect_to(events_path)
    end

    it "non crea un evento non valido: dati mancanti" do
      expect {
        post :create, params: {
          event: attributes_for(:event, nome: "")
        }
      }.not_to change(Event, :count)

      expect(response).to render_template(:new)
    end
  end

  describe "PATCH #update" do
    let(:event) { create(:event, user: organizzatore) }

    it "aggiorna un evento valido" do
      patch :update, params: {
        id: event.id,
        event: { nome: "Evento aggiornato" }
      }

      expect(response).to redirect_to(my_events_events_path)
      expect(event.reload.nome).to eq("Evento aggiornato")
    end

    it "non aggiorna un evento non valido: dati mancanti" do
      patch :update, params: { 
        id: event.id, 
        event: { nome: "" } 
      }

      expect(response).to render_template(:edit)
    end

    it "rimuove l'iscrizione più recente se due eventi finiscono nella stessa data dopo una modifica" do
      evento1 = create(:event, data_inizio: Date.tomorrow, created_at: 2.days.ago)
      evento2 = create(:event, data_inizio: Date.today + 2, created_at: 1.day.ago)
    
      Subscription.create!(user: partecipante, event: evento1)
      Subscription.create!(user: partecipante, event: evento2)
    
      session[:user_id] = evento1.user.id
      Current.user = evento1.user
    
      patch :update, params: {
        id: evento1.id,
        event: { data_inizio: evento2.data_inizio }
      }
    
      expect(partecipante.subscribed_events).to include(evento1)
      expect(partecipante.subscribed_events).not_to include(evento2)
    end
  end

  describe "DELETE #destroy" do
    it "elimina un evento" do
      event = create(:event, user: organizzatore)
      delete :destroy, params: { id: event.id }

      expect(response).to redirect_to(my_events_events_path)
      expect(Event.exists?(event.id)).to be_falsey
    end
  end

  describe "GET #participants" do
    it "visualizza la lista dei partecipanti ad un evento" do
      event = create(:event, user: organizzatore)
      event.attendees << partecipante

      get :participants, params: { id: event.id }

      expect(assigns(:participants)).to include(partecipante)
    end
  end

  describe "DELETE #remove_participant" do
    it "rimuove un partecipante da un evento" do
      event = create(:event, user: organizzatore)
      event.attendees << partecipante

      delete :remove_participant, params: { id: event.id, participant_id: partecipante.id }

      expect(response).to redirect_to(participants_event_path(event))
      expect(event.attendees).not_to include(partecipante)
    end
  end
end