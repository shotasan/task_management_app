class Group < ApplicationRecord
  has_many :group_participants, dependent: :destroy
  has_many :users, through: :group_participants
end
