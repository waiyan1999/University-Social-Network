# app/models/notification.rb
class Notification < ApplicationRecord
  # Who did the action (liker/commenter/follower)
  belongs_to :actor, class_name: "User"
  # Who is receiving this notification
  belongs_to :recipient, class_name: "User"

  # What this notification is about
  belongs_to :notifiable, polymorphic: true

  validates :action, presence: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def read?
    read_at.present?
  end

  def mark_as_read!
    update!(read_at: Time.current) unless read?
  end
end
