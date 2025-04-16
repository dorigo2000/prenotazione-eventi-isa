require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:user) { create(:user) }

  before do
    session[:user_id] = user.id
  end

  describe "GET #index" do
    it "reindirizza alla schermata di login se l'utente non è loggato" do
      session[:user_id] = nil
      get :index
      expect(response).to redirect_to(root_path)
    end

    it "visualizza che non ha ricevuto notifiche" do
      get :index

      expect(assigns(:notifications)).to eq([])
      expect(response).to have_http_status(:ok)
    end

    it "visualizza le notifiche ricevute" do
      notification1 = create(:notification, user: user, created_at: 1.day.ago)

      get :index

      expect(assigns(:notifications)).to eq([notification1])
    end
  end

  describe "PATCH #mark_as_read" do
    it "segna una notifica come letta" do
      notification1 = create(:notification, user: user, created_at: 1.day.ago)

      patch :mark_as_read, params: { id: notification1.id }

      expect(notification1.reload.letto).to be true
      expect(response).to redirect_to(events_path)
    end
  end
end
