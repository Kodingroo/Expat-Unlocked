class UserDocument < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  belongs_to :user
  belongs_to :document, optional: true

  # validates :photo, presence: true
  # validates :doc_type, presence: true
  # FILTER = %w(due_date doc_type state)
  def self.most_expensive_bill(current_user)
    current_user.user_documents.pluck("current_due_amount").max
  end
  
  def self.least_expensive_bill
    current_user.user_documents.pluck("current_due_amount").max
  end

  def self.average_all_time
    average(:current_due_amount).where(user_id: current_user)
  end

  def self.average_this_month
    average(:current_due_amount).where(user_id: current_user)
  end
end

