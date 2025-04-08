class Event < ApplicationRecord
  belongs_to :user
  has_many :subscriptions, dependent: :destroy
  has_many :attendees, through: :subscriptions, source: :user
  has_many :notifications, dependent: :nullify

  validates :nome, presence: {message: "evento è obbligatorio"}
  validate :data_inizio_check, :orario_inizio_check, :data_fine_check, :orario_fine_check, :paese_check
  validates :indirizzo, presence: {message: "è obbligatorio"}
  validate :max_partecipanti_check

  def num_partecipanti
    attendees.count
  end

  private

  def paese_check
    if paese.blank?
      errors.add(:base, "Città è obbligatoria")
    end
  end

  def data_inizio_check
    if data_inizio.present?
        if data_inizio <= Date.today
          errors.add(:base, "Data di inizio non può essere oggi o nel passato")
        end
    else
        errors.add(:base, "Data di inizio è obbligatoria")
    end
  end

  def data_fine_check
    if data_fine.present?
        if data_fine < Date.today
          errors.add(:base, "Data di fine non può essere nel passato")
        end
        if data_inizio.present? && data_fine < data_inizio
          errors.add(:base, "Data di fine non può essere prima della data di inizio")
        end
    else
        errors.add(:base, "Data di fine è obbligatoria")
    end
  end

  def orario_inizio_check
    if orario_inizio.blank?
      errors.add(:base, "Ora di inizio è obbligatoria")
    end
  end

  def orario_fine_check
    if orario_fine.blank?
      errors.add(:base, "Ora di fine è obbligatoria")
    end
  end

  def max_partecipanti_check
    if max_partecipanti.present?
        if max_partecipanti < 1
          errors.add(:base, "Numero massimo di partecipanti deve essere maggiore di 0")
        end
    else
        errors.add(:base, "Numero massimo di partecipanti è obbligatorio")
    end
  end
end
