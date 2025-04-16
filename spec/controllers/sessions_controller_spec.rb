require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  describe "GET #new" do
    it "visualizza la shcermata di login" do
      get :new
      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end  

  describe "POST #create" do
    it "effettua il login e reindirizza alla homepage" do
      post :create, params: { email: user.email, password: "password123" }

      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(events_path)
    end

    it "non effettua il login: credenziali errate" do
      post :create, params: { email: user.email, password: "123password" }

      expect(session[:user_id]).to be_nil
      expect(flash.now[:alert]).to eq("Siamo spiacenti, le credenziali sono errate!")
      expect(response).to render_template(:new)
    end

    it "non effettua il login: parametri assenti" do
      post :create, params: { email: "" }
    
      expect(session[:user_id]).to be_nil
      expect(flash.now[:alert]).to eq("Siamo spiacenti, le credenziali sono errate!")
      expect(response).to render_template(:new)
    end
  end

  describe "DELETE #destroy" do
    it "effettua il logout e reindirizza alla schermata di login" do
      session[:user_id] = user.id

      delete :destroy

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Logout completato con successo!")
    end
  end
end
