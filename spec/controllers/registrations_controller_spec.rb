require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do

  describe "GET #new" do
    it "visualizza la pagina di registrazione" do
      get :new
      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    it "crea un utente valido" do
      expect {
        post :create, params: { user: attributes_for(:user) }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(events_path)
      expect(flash[:notice]).to eq("Registrazione completata con successo!")
    end

    it "non crea un utente non valido: dati mancanti" do
      user_non_valido = attributes_for(:user, nome: "")

      expect {
        post :create, params: { user: user_non_valido }
      }.not_to change(User, :count)

      expect(response).to render_template(:new)
    end
  end
end
