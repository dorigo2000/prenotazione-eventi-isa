require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "richiede il nome:" do
    let(:event) { build(:event) }
  
    it "è invalido senza nome" do
      event.nome = nil
      expect(event).not_to be_valid
      expect(event.errors[:nome].first).to include("è obbligatorio")
    end
  end

  describe "richiede l'indirizzo:" do
    let(:event) { build(:event) }
  
    it "è invalido senza indirizzo" do
      event.indirizzo = nil
      expect(event).not_to be_valid
      expect(event.errors[:indirizzo]).to include("è obbligatorio")
    end
  end

  describe "richiede la città:" do
    let(:event) { build(:event) }
  
    it "è invalido senza città" do
      event.paese = nil
      expect(event).not_to be_valid
      expect(event.errors[:base]).to include("Città è obbligatoria")
    end
  end

  describe "richiede la data di inizio:" do
    let(:event) { build(:event) }

    it "è invalido senza data di inizio" do
      event.data_inizio = nil
      expect(event).not_to be_valid
      expect(event.errors[:base].first).to include("è obbligatoria")
    end
  end

  describe "richiede una data di inizio valida:" do
    let(:event) { build(:event) }

    it "è invalido con data di inizio oggi o nel passato" do
      event.data_inizio = Date.yesterday
      expect(event).not_to be_valid
      expect(event.errors[:base].first).to include("non può essere oggi o nel passato")
    end
  end

  describe "richiede la data di fine:" do
    let(:event) { build(:event) }

    it "è invalido senza data di fine" do
      event.data_fine = nil
      expect(event).not_to be_valid
      expect(event.errors[:base].first).to include("è obbligatoria")
    end
  end

  describe "richiede una data di fine valida:" do
    let(:event) { build(:event) }

    it "è invalido con data di fine nel passato" do
      event.data_fine = Date.yesterday
      expect(event).not_to be_valid
      expect(event.errors[:base].first).to include("non può essere nel passato")
    end

    it "è invalido con data di fine prima della data di inizio" do
      event.data_inizio = Date.today + 5.days
      event.data_fine = Date.today + 4.days
      expect(event).not_to be_valid
      expect(event.errors[:base].first).to include("non può essere prima della data di inizio")
    end
  end

  describe "richiede l'ora di inizio:" do
    let(:event) { build(:event) }

    it "è invalido senza ora di inizio" do
      event.orario_inizio = nil
      expect(event).not_to be_valid
      expect(event.errors[:base]).to include("Ora di inizio è obbligatoria")
    end
  end

  describe "richiede l'ora di fine:" do
    let(:event) { build(:event) }

    it "è invalido senza ora di fine" do
      event.orario_fine = nil
      expect(event).not_to be_valid
      expect(event.errors[:base]).to include("Ora di fine è obbligatoria")
    end
  end

  describe "richiede il numero massimo di partecipanti:" do
    let(:event) { build(:event) }

    it "è invalido senza numero massimo di partecipanti" do
      event.max_partecipanti = nil
      expect(event).not_to be_valid
      expect(event.errors[:base]).to include("Numero massimo di partecipanti è obbligatorio")
    end
  end

  describe "richiede un numero massimo di partecipanti valido:" do
    let(:event) { build(:event) }

    it "è invalido con un numero massimo di partecipanti minore di 1" do
      event.max_partecipanti = 0
      expect(event).not_to be_valid
      expect(event.errors[:base]).to include("Numero massimo di partecipanti deve essere maggiore di 0")
    end
  end

  describe "test partecipanti ad un evento:" do
    let(:event) { create(:event) }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    before do
      event.attendees << user1
      event.attendees << user2
    end

    it "restituisce il numero corretto di partecipanti" do
      expect(event.num_partecipanti).to eq(2)
    end
  end

  describe "test notifiche:" do
    it "può avere più notifiche" do
      event = create(:event)
      create_list(:notification, 2, event: event)
    
      expect(event.notifications.count).to eq(2)
    end
  end

  describe "test cancellazione iscrizioni:" do
    let(:event) { create(:event) }
    let(:user) { create(:user) }
  
    it "cancella le iscrizioni quando l'evento viene eliminato" do
      create(:subscription, user: user, event: event)
      expect { event.destroy }.to change { Subscription.count }.by(-1)
    end
  end

  describe "test aggiornamento evento:" do
    let(:event) { create(:event) }
  
    it "modifica correttamente la data di inizio" do
      new_date = Date.today + 7
      event.update!(data_inizio: new_date)
      expect(event.reload.data_inizio).to eq(new_date)
    end
  end
  
  describe "test numero massimo partecipanti:" do
    let(:event) { create(:event, max_partecipanti: 2) }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
  
    it "accetta iscrizioni fino al numero massimo di partecipanti" do
      create(:subscription, user: user1, event: event)
      create(:subscription, user: user2, event: event)
  
      expect { create(:subscription, user: user3, event: event) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  

end