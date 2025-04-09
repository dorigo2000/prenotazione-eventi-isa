require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe "validazione attributi:" do
    let(:user) { create(:user) }
    let(:event) { create(:event, max_partecipanti: 2) }

    it "è valida con tutti gli attributi richiesti" do
      allow_any_instance_of(Subscription).to receive(:no_conflicting_events).and_return(true)
      subscription = create(:subscription, user: user, event: event)
      expect(subscription).to be_valid
    end
  end

  describe "è invalida se già iscritto a quell'evento:" do
    let(:user) { create(:user) }
    let(:event) { create(:event) }

    it "impedisce l'iscrizione doppia a uno stesso evento" do
      create(:subscription, user: user, event: event)
      duplicate_subscription = build(:subscription, user: user, event: event)
      
      expect(duplicate_subscription).not_to be_valid
      expect(duplicate_subscription.errors[:user_id]).to include("Sei già iscritto a questo evento!")
    end
  end

  describe "è invalida se già iscritto ad un evento nella stessa data:" do
    let(:user) { create(:user) }
    let(:event) { create(:event) }
    
    it "impedisce l'iscrizione a eventi con la stessa data" do
      event2 = create(:event, data_inizio: event.data_inizio)
      create(:subscription, user: user, event: event)
  
      conflicting_subscription = build(:subscription, user: user, event: event2)
      expect(conflicting_subscription).not_to be_valid
      expect(conflicting_subscription.errors[:base]).to include("Impossibile effettuare l'iscrizione, sei già iscritto a un evento nella stessa data!")
    end
  end

  describe "è invalida se è già stato raggiunto il numero massimo di partecipanti:" do
    let(:user) { create(:user) }
    let(:event) { create(:event, max_partecipanti: 2) }

    it "impedisce l'iscrizione oltre il numero massimo di partecipanti" do
      user2 = create(:user)
      user3 = create(:user)
  
      create(:subscription, user: user, event: event)
      create(:subscription, user: user2, event: event)
  
      over_limit_subscription = build(:subscription, user: user3, event: event)
      expect(over_limit_subscription).not_to be_valid
      expect(over_limit_subscription.errors[:base]).to include("Numero massimo di partecipanti raggiunto")
    end
  end

  describe "test notifica raggiungimento numero massimo di partecipanti:" do
    let(:user) { create(:user) }
    let(:event) { create(:event, max_partecipanti: 2) }

    it "crea una notifica quando l'evento raggiunge il numero massimo di partecipanti" do
      user2 = create(:user)
      expect {
        create(:subscription, user: user, event: event)
        create(:subscription, user: user2, event: event)
      }.to change(Notification, :count).by(1)
  
      notification = Notification.last
      expect(notification.messaggio).to eq("L'evento '#{event.nome}' ha raggiunto il numero massimo di partecipanti.")
    end
  end

  describe "test eliminazione iscrizione:" do
    let(:user) { create(:user) }
    let(:event) { create(:event) }

    it "rimuove l'utente dall'evento quando si cancella un'iscrizione" do
      subscription = create(:subscription)
    
      expect { subscription.destroy }.to change { subscription.event.attendees.count }.by(-1)
    end    
  end

  describe "è invalida se l'utente prova ad iscriversi ad un evento passato:" do
    let(:user) { create(:user) }
    let(:event) { create(:event, data_inizio: 2.days.ago, data_fine: 1.day.from_now) }

    it "impedisce l'iscrizione ad eventi passati" do
      allow_any_instance_of(Event).to receive(:data_inizio_check).and_return(nil)
      subscription = build(:subscription, user: user, event: event)

      expect(subscription).not_to be_valid
      expect(subscription.errors[:base]).to include("Non puoi iscriverti a un evento già passato")
    end
  end
end