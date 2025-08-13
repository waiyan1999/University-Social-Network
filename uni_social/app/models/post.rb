class Post < ApplicationRecord
  belongs_to :user
  has_many   :comments, dependent: :destroy
  has_many   :likes,    dependent: :destroy

  has_one_attached :photo

  validates :body, presence: true, unless: -> { photo.attached? }

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end
