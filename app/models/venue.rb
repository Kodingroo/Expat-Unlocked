class Venue < ApplicationRecord
  belongs_to :user
  validates :address, presence: true
  geocoded_by :name
  after_validation :geocode, if: :will_save_change_to_address?
end
