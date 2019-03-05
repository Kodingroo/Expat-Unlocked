class UserDocument < ApplicationRecord
  belongs_to :user
  belongs_to :document, optional: true 

  # validates :title, presence: true
  # validates :doc_type, presence: true
  validates :photo, presence: true
  mount_uploader :photo, PhotoUploader
end
