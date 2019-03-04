class UserDocument < ApplicationRecord
  belongs_to :user
  belongs_to :document

  validates :title, presence: true
  validates :type, presence: true
  validates :photo, uniqueness: true, presence: true
end
