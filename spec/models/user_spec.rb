require 'rails_helper'

RSpec.describe User, type: :model do
  describe "richiede il nome:" do
    let(:user) { build(:user) }
  
    it "è invalido senza nome" do
      user.nome = nil
      expect(user).not_to be_valid
      expect(user.errors[:nome]).to include("è obbligatorio")
    end
  end

  describe "richiede il cognome:" do
    let(:user) { build(:user) }
  
    it "è invalido senza cognome" do
      user.cognome = nil
      expect(user).not_to be_valid
      expect(user.errors[:cognome]).to include("è obbligatorio")
    end
  end

  describe "richiede il telefono:" do
    let(:user) { build(:user) }
  
    it "è invalido senza telefono" do
      user.telefono = nil
      expect(user).not_to be_valid
      expect(user.errors[:telefono]).to include("è obbligatorio")
    end
  end

  describe "richiede un telefono valido:" do
    let(:user) { build(:user) }
  
    it "è invalido con meno di 10 cifre" do
      user.telefono = "012345678"
      expect(user).not_to be_valid
      expect(user.errors[:telefono]).to include("deve contenere esattamente 10 cifre")
    end

    it "è invalido con più di 10 cifre" do
      user.telefono = "01234567890"
      expect(user).not_to be_valid
      expect(user.errors[:telefono]).to include("deve contenere esattamente 10 cifre")
    end

    it "è invalido con lettere" do
      user.telefono = "01234abcde"
      expect(user).not_to be_valid
      expect(user.errors[:telefono]).to include("deve contenere esattamente 10 cifre")
    end
  end

  describe "richiede la data di nascita:" do
    let(:user) { build(:user) }
  
    it "è invalido senza data di nascita" do
      user.data_nascita = nil
      expect(user).not_to be_valid
      expect(user.errors[:data_nascita]).to include("è obbligatoria")
    end
  end

  describe "richiede una data di nascita valida:" do
    let(:user) { build(:user) }
  
    it "è invalido con una data di nascita nel futuro" do
      user.data_nascita = Date.today + 1.day
      expect(user).not_to be_valid
      expect(user.errors[:base].first).to include("non può essere nel futuro")
    end
  end

  describe "richiede l'email:" do
    let(:user) { build(:user) }
  
    it "è invalido senza email" do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("è obbligatoria")
    end
  end

  describe "richiede un'email unica:" do
    let!(:user) { create(:user, email: "prova@gmail.com") }
  
    it "è invalido con un'email già registrata" do
      user2 = build(:user, email: "prova@gmail.com")
      expect(user2).not_to be_valid 
      expect(user2.errors[:email]).to include("è già stata registrata")
    end
  end

  describe "richiede un'email valida:" do
    let(:user) { build(:user) }
  
    it "è invalido con un'email senza @" do
      user.email = "provagmail.com"
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("non ha un formato valido")
    end
  
    it "è invalido con un'email senza dominio" do
      user.email = "prova@"
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("non ha un formato valido")
    end
  
    it "è invalido con un'email con spazi" do
      user.email = "prova @gmail.com"
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("non ha un formato valido")
    end
  end

  describe "richiede la password:" do
    let(:user) { build(:user) }
  
    it "è invalido senza password" do
      user.password = nil
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("è obbligatoria")
    end
  end

  describe "richiede una password valida:" do
    let(:user) { build(:user) }
  
    it "è invalido con meno di 8 caratteri" do
      user.password = "abcdefg"
      user.password_confirmation = "abcdefgh"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("deve essere di almeno 8 caratteri")
    end
  end

  describe "richiede che le password coincidano:" do
    let(:user) { build(:user) }
  
    it "è invalido se le password non coincidono" do
      user.password = "password123"
      user.password_confirmation = "123password"
      expect(user).not_to be_valid
      expect(user.errors[:base]).to include("Le password non coincidono")
    end
  end

  describe "test iscrizione a più eventi:" do
    let(:user) { create(:user) }
    let(:event1) { create(:event, data_inizio: Date.today + 10) }
    let(:event2) { create(:event, data_inizio: Date.today + 20) }

    before do
      create(:subscription, user: user, event: event1)
      create(:subscription, user: user, event: event2)
    end

    it "restituisce il numero corretto di eventi a cui l'utente è iscritto" do
      expect(user.numero_iscrizioni).to eq(2)
    end
  end
end

