class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :event

  after_create :check_max_participants
  
  validates :user_id, uniqueness: { scope: :event_id, message: "Sei già iscritto a questo evento!" }
  validate :no_conflicting_events
  validate :max_partecipanti_reached
  validate :event_not_in_the_past

  private

  def no_conflicting_events
    overlapping_events = user.subscribed_events.where("data_inizio = ?", event.data_inizio)
    
    if overlapping_events.exists?
      errors.add(:base, "Impossibile effettuare l'iscrizione, sei già iscritto a un evento nella stessa data!")
    end
  end

  def check_max_participants
    if event.subscriptions.count >= event.max_partecipanti
      Notification.create(
        user: event.user,
        event: event,
        messaggio: "L'evento '#{event.nome}' ha raggiunto il numero massimo di partecipanti."
      )
    end
  end

  def max_partecipanti_reached
    if event.attendees.count >= event.max_partecipanti
      errors.add(:base, "Numero massimo di partecipanti raggiunto")
    end
  end

  def event_not_in_the_past
    if event.data_inizio < Date.today
      errors.add(:base, "Non puoi iscriverti a un evento già passato")
    end
  end
end
