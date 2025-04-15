require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:partecipante) { create(:user) }
  let(:event) { create(:event) }

  before do
    session[:user_id] = partecipante.id
  end

  describe "GET #index" do
    it "reindirizza alla schermata di login se l'utente non è loggato" do
      session[:user_id] = nil
      get :index
      expect(response).to redirect_to(root_path)
    end

    it "visualizza che l'utente non ha iscrizioni" do
      get :index
    
      expect(response).to be_successful
      expect(assigns(:subscriptions)).to be_empty
    end

    it "visualizza le iscrizioni" do
      event1 = create(:event)
      partecipante.subscribed_events << event1

      get :index

      expect(response).to be_successful
      expect(assigns(:subscriptions)).to match_array([event1])
    end
  end

  describe "POST #create" do
    it "effettua una nuova iscrizione" do
      post :create, params: { id: event.id }

      expect(partecipante.subscribed_events).to include(event)
      expect(flash[:notice]).to eq("Iscrizione effettuata con successo!")
      expect(response).to redirect_to(events_path)
    end

    it "non effettua una nuova iscrizione" do
      allow_any_instance_of(Subscription).to receive(:save).and_return(false)
      allow_any_instance_of(Subscription).to receive_message_chain(:errors, :full_messages).and_return(["Errore di iscrizione"])

      post :create, params: { id: event.id }

      expect(flash[:alert]).to eq("Errore di iscrizione")
      expect(response).to redirect_to(events_path)
    end
  end

  describe "DELETE #destroy" do
    it "elimina l'iscrizione ad un evento" do
      partecipante.subscribed_events << event

      delete :destroy, params: { id: event.id }

      expect(partecipante.subscribed_events).not_to include(event)
      expect(response).to redirect_to(subscriptions_path)
      expect(flash[:notice]).to eq("La tua iscrizione è stata cancellata con successo!")
    end
  end
end