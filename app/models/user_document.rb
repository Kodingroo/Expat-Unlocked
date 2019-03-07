class UserDocument < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  belongs_to :user
  belongs_to :document, optional: true

  # validates :photo, presence: true
  # validates :doc_type, presence: true
  # FILTER = %w(due_date doc_type state)
end

