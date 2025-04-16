require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  controller do
    def index
      render plain: "Login effettuato con successo!"
    end
  end

  describe "GET #index" do
    context "se l'utente è loggato" do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it "permette l'accesso" do
        get :index
        expect(response).to be_successful
        expect(response.body).to eq("Login effettuato con successo!")
      end
    end

    context "se l'utente non è loggato" do
      it "reindirizza alla schermata di login" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
