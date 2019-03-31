class Group < ApplicationRecord
  has_many :group_participants, dependent: :destroy
end
