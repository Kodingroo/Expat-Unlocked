class UserDocument < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  belongs_to :user
  belongs_to :document, optional: true
  mount_base64_uploader :photo, PhotoUploader
  # validates :photo, presence: true
  # validates :doc_type, presence: true
  # FILTER = %w(due_date doc_type state)
end
