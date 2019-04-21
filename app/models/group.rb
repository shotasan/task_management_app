class Group < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }

  has_many :group_participants, dependent: :destroy
  has_many :users, through: :group_participants
end
