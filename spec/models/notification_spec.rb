require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:user) { create(:user) }
  let(:event) { create(:event) }

  describe "validazioni attributi" do
    it "è valida con tutti gli attributi richiesti" do
      notification = build(:notification, user: user, event: event)
      expect(notification).to be_valid
    end

    it "è invalida senza messaggio" do
      notification = build(:notification, user: user, messaggio: nil)
      expect(notification).not_to be_valid
      expect(notification.errors[:messaggio]).to include("è obbligatorio")
    end

    it "è valida senza un evento associato" do
      notification = build(:notification, user: user, event: nil)
      expect(notification).to be_valid
    end

    it "è invalida senza un utente" do
      notification = build(:notification, user: nil, event: event)
      expect(notification).not_to be_valid
      expect(notification.errors[:user]).to include("must exist")
    end
  end

  describe "test scope unread" do
    it "restituisce solo notifiche non lette" do
      read_notification = create(:notification, user: user, letto: true)
      unread_notification = create(:notification, user: user, letto: nil)

      expect(Notification.unread).to include(unread_notification)
      expect(Notification.unread).not_to include(read_notification)
    end
  end
end
