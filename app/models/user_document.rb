class UserDocument < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  belongs_to :user
  belongs_to :document

  validates :title, presence: true
  validates :doc_type, presence: true
end
