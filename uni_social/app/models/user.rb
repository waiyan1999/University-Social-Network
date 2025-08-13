class User < ApplicationRecord
  # If you’re not using :trackable, keep it removed to avoid extra columns errors.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # , :trackable  # enable only if you added trackable columns

  has_one  :profile,  dependent: :destroy
  has_many :posts,    dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes,    dependent: :destroy

  # Notifications
  has_many :sent_notifications,
           class_name: "Notification",
           foreign_key: :actor_id,
           dependent: :destroy

  has_many :received_notifications,
           class_name: "Notification",
           foreign_key: :recipient_id,
           dependent: :destroy

  

  after_create :build_default_profile

  private

  def build_default_profile
    return if profile.present?
    create_profile!(
      full_name: email.to_s.split("@").first.to_s.capitalize,
      major: "CST",
      year: 1,
      bio: "",
      avatar_url: nil
    )
  end
end
