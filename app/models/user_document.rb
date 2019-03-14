class UserDocument < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  belongs_to :user
  belongs_to :document, optional: true

  def self.current_year_user_bills(current_user)
    current_user.user_documents.where("created_at > ?", Date.new(Time.now.year, 1, 1)).pluck("current_due_amount")
  end

  def self.bills_hash(bills)
    if bills.size.zero? || bills.include?(nil)
      {
        max: 0,
        min: 0,
        average: 0
      }
    else
      {
        max: bills.max,
        min: bills.min,
        average: (bills.inject(0.0) { |sum, el| sum + el } / bills.size).to_i
      }
    end
  end

  def self.general_bills(current_user)
    bills = current_year_user_bills(current_user)
    bills_hash(bills)
  end

  def self.search_stats(document, current_user)
    type = Document.find_by(company_name: document)

    bills = type.user_documents.where(user_id: current_user.id).pluck("current_due_amount")
    bills_hash(bills)
  end
end
