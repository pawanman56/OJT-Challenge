class Post < ApplicationRecord

  has_many :comments

  belongs_to :user

  validates :user_id, presence: true
  validates :description, presence: true, length: { maximum: 140 }

end
