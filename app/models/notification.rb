class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :event, optional: true

  validates :messaggio, presence: {message: "è obbligatorio"}

  scope :unread, -> { where(letto: nil) }
end
