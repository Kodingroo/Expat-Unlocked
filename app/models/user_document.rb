class UserDocument < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  belongs_to :user
  belongs_to :document, optional: true
  # validates :photo, presence: true
  # validates :doc_type, presence: true
  # FILTER = %w(due_date doc_type state)
  def self.most_expensive_bill(current_user)
    max_bill = current_user.user_documents.pluck("current_due_amount").max
    current_user.user_documents.where("created_at > ?", Date.new(Time.now.year, 1, 1)).where(current_due_amount: max_bill)
  end

  def self.least_expensive_bill(current_user)
    min_bill = current_user.user_documents.pluck("current_due_amount").min
    current_user.user_documents.where("created_at > ?", Date.new(Time.now.year, 1, 1)).where(current_due_amount: min_bill)
  end

  def self.average_current_year(current_user)
    current_user_docs = current_user.user_documents.where("created_at > ?", Date.new(Time.now.year, 1, 1))
    due_array = current_user_docs.pluck("current_due_amount")
    due_array.inject(0.0) { |sum, el| sum + el } / due_array.size
  end

  def self.average_this_month
    average(:current_due_amount).where(user_id: current_user)
  end
end
